package cn.luooyii.ferry.server.controller.authentication

import com.interest.controller.login.LoginFailureExcepiton
import com.interest.dao.UserDao
import com.interest.model.UserEntity
import com.interest.model.UserGithubEntity
import com.interest.properties.GithubProperties
import com.interest.service.UserGithubService
import com.interest.utils.DateUtil
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.configurationprocessor.json.JSONException
import org.springframework.boot.configurationprocessor.json.JSONObject
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.util.LinkedMultiValueMap
import org.springframework.util.MultiValueMap
import org.springframework.web.client.RestTemplate


@Service(value = "gitHubAuthentication")
class GitHubAuthentication : MyAuthentication {

    private val logger = LoggerFactory.getLogger(this.javaClass)

    @Autowired
    private val userDao: UserDao? = null

    @Autowired
    private val userGithubService: UserGithubService? = null

    @Autowired
    private val githubProperties: GithubProperties? = null

    private val restTemplate = RestTemplate()

    @Transactional
    override fun getUserId(code: String): String? {

        val requestEntity = LinkedMultiValueMap<String, String>()
        requestEntity.add("client_id", githubProperties!!.getClientId())
        requestEntity.add("client_secret", githubProperties!!.getClientSecret())
        requestEntity.add("code", code)

        logger.info("**********client_id:" + requestEntity["client_id"] + ";client_secret:" + requestEntity["client_secret"] + "**********")

        var responseEntity = restTemplate.postForEntity(GITHUB_ACCESSS_TOKEN_URL, requestEntity, String::class.java)

        val message = responseEntity.body!!.trim { it <= ' ' }

        val access_token = message.split("&".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()[0].split("=".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()[1]

        if (access_token == null || "" == access_token) {
            throw LoginFailureExcepiton(message)
        }

        val url = "$GITHUB_USER_URL?access_token=$access_token"

        responseEntity = restTemplate.getForEntity(url, String::class.java)

        var userEntity: UserEntity? = null

        try {

            val githubUserInfo = JSONObject(responseEntity.body!!.trim { it <= ' ' })

            val login = githubUserInfo.getString("login") ?: throw LoginFailureExcepiton(githubUserInfo.toString())

            userEntity = userDao!!.getEntityByGithubid(login)

            return if (userEntity == null) {
                insertUser(githubUserInfo)
            } else {
                String.valueOf(userEntity!!.getId())
            }

        } catch (e: Exception) {
            e.printStackTrace()
        }

        return null
    }

    @Throws(JSONException::class)
    private fun insertUser(githubToken: JSONObject): String {
        val userEntity = UserEntity()
        userEntity.setEmail(githubToken.getString("email"))
        userEntity.setHeadimg(githubToken.getString("avatar_url"))
        //        userEntity.setLoginName(githubToken.getString("login"));
        userEntity.setName(githubToken.getString("login"))
        userEntity.setUrl(githubToken.getString("html_url"))
        userEntity.setGithubid(githubToken.getString("login"))
        userEntity.setUsertype(0)
        userEntity.setCreateTime(DateUtil.currentTimestamp())
        userDao!!.insertUser(userEntity)

        val userGithubEntity = UserGithubEntity()
        userGithubEntity.setLogin(githubToken.getString("login"))
        userGithubEntity.setAvatarUrl(githubToken.getString("avatar_url"))
        userGithubEntity.setHtmlUrl(githubToken.getString("html_url"))
        userGithubEntity.setEmail(githubToken.getString("email"))
        userGithubEntity.setUserid(userEntity.getId())
        userGithubService!!.insertEntity(userGithubEntity)

        return String.valueOf(userEntity.getId())
    }

    companion object {

        private val GITHUB_ACCESSS_TOKEN_URL = "https://github.com/login/oauth/access_token"

        private val GITHUB_USER_URL = "https://api.github.com/user"
    }
}
