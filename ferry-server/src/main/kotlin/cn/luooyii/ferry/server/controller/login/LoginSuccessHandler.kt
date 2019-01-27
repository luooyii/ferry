package cn.luooyii.ferry.server.controller.login

import cn.luooyii.ferry.server.controller.authentication.MyAuthenticationToken
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.security.authentication.InternalAuthenticationServiceException
import org.springframework.security.core.Authentication
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.oauth2.common.OAuth2AccessToken
import org.springframework.security.oauth2.common.exceptions.UnapprovedClientAuthenticationException
import org.springframework.security.oauth2.provider.*
import org.springframework.security.oauth2.provider.token.AuthorizationServerTokenServices
import org.springframework.stereotype.Component

import javax.annotation.Resource
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import java.io.IOException
import java.util.Base64
import java.util.HashMap


@Component
class LoginSuccessHandler {

    @Resource(name = "myUserDetailsService")
    private val userDetailsService: UserDetailsService? = null

    @Autowired
    private val clientDetailsService: ClientDetailsService? = null

    @Autowired
    private val authorizationServerTokenServices: AuthorizationServerTokenServices? = null

    /*
	 * @Autowired private ObjectMapper objectMapper;
	 */

    @Throws(IOException::class)
    fun getAccessToken(request: HttpServletRequest, response: HttpServletResponse,
                       authentication: Authentication): OAuth2AccessToken {

        val auth2Request = getOAuth2Request(request, response, authentication)

        val user = getUserDetails(authentication)

        val authenticationTokenResult = MyAuthenticationToken(user,
                user.authorities)

        authenticationTokenResult.setDetails(authentication.details)

        val auth2Authentication = OAuth2Authentication(auth2Request, authenticationTokenResult)

        val token = authorizationServerTokenServices!!.createAccessToken(auth2Authentication)

        return token
    }

    @Throws(IOException::class)
    fun getOAuth2Request(request: HttpServletRequest, response: HttpServletResponse,
                         authentication: Authentication): OAuth2Request {
        val header = request.getHeader("Authorization")

        if (header == null || !header.startsWith("Basic ")) {
            throw UnapprovedClientAuthenticationException("请求头中无client信息")
        }

        val tokens = extractAndDecodeHeader(header, request)
        assert(tokens.size == 2)

        val clientId = tokens[0]
        val clientSecret = tokens[1]

        val clientDetails = clientDetailsService!!.loadClientByClientId(clientId)


        if (clientDetails == null) {
            throw UnapprovedClientAuthenticationException("clientId对应的配置信息不存在：$clientId")
        } else if (clientSecret != null && clientSecret != clientDetails.clientSecret.substring(6, 12)) {
            throw UnapprovedClientAuthenticationException("clientSecret不匹配：$clientId")
        }

        val tokenRequest = TokenRequest(HashMap(), clientId, clientDetails.scope,
                "custom")

        val auth2Request = tokenRequest.createOAuth2Request(clientDetails)

        return auth2Request
    }

    fun getUserDetails(authentication: Authentication): UserDetails {

        /*
		 * Collection<SimpleGrantedAuthority> collection = new
		 * HashSet<SimpleGrantedAuthority>(); collection.add(new
		 * SimpleGrantedAuthority("ROLE_ADMIN"));
		 */
        /*
		 * Authentication userAuth = new
		 * UsernamePasswordAuthenticationToken(userEntity.getLoginName(),
		 * userEntity.getPassword(), collection);
		 */

        /*
		 * SmsCodeAuthenticationToken smsCodeAuthenticationToken =
		 * (SmsCodeAuthenticationToken) authentication;
		 */

        val user = userDetailsService!!.loadUserByUsername(authentication.principal as String)
                ?: throw InternalAuthenticationServiceException("无法获取用户信息")

        return user
    }

    @Throws(IOException::class)
    private fun extractAndDecodeHeader(header: String, request: HttpServletRequest): Array<String> {

        val base64Token = header.substring(6).toByteArray(charset("UTF-8"))
        val decoded: ByteArray
        try {
            decoded = Base64.getDecoder().decode(base64Token)
        } catch (e: IllegalArgumentException) {
            throw BadCredentialsException("Failed to decode basic authentication token")
        }

        val token = String(decoded, "UTF-8")

        val delim = token.indexOf(":")

        if (delim == -1) {
            throw BadCredentialsException("Invalid basic authentication token")
        }
        return arrayOf(token.substring(0, delim), token.substring(delim + 1))
    }

    /*
	 * @Override public void onAuthenticationSuccess(HttpServletRequest request,
	 * HttpServletResponse response, Authentication authentication) throws
	 * IOException, ServletException {
	 * 
	 * String header = request.getHeader("Authorization");
	 * 
	 * if (header == null || !header.startsWith("Basic ")) { throw new
	 * UnapprovedClientAuthenticationException("请求头中无client信息"); }
	 * 
	 * String[] tokens = extractAndDecodeHeader(header, request); assert
	 * tokens.length == 2;
	 * 
	 * String clientId = tokens[0]; String clientSecret = tokens[1];
	 * 
	 * ClientDetails clientDetails =
	 * clientDetailsService.loadClientByClientId(clientId);
	 * 
	 * if (clientDetails == null) { throw new
	 * UnapprovedClientAuthenticationException("clientId对应的配置信息不存在：" + clientId); }
	 * else if (clientSecret != null &&
	 * clientSecret.equals(clientDetails.getClientSecret())) { throw new
	 * UnapprovedClientAuthenticationException("clientSecret不匹配：" + clientId); }
	 * 
	 * TokenRequest tokenRequest = new TokenRequest(new HashMap<String, String>(),
	 * clientId, clientDetails.getScope(), "custom");
	 * 
	 * OAuth2Request auth2Request = tokenRequest.createOAuth2Request(clientDetails);
	 * 
	 * Collection<SimpleGrantedAuthority> collection = new
	 * HashSet<SimpleGrantedAuthority>(); collection.add(new
	 * SimpleGrantedAuthority("ROLE_ADMIN"));
	 * 
	 * Authentication userAuth = new
	 * UsernamePasswordAuthenticationToken(userEntity.getLoginName(),
	 * userEntity.getPassword(), collection);
	 * 
	 * 
	 * OAuth2Authentication auth2Authentication = new
	 * OAuth2Authentication(auth2Request, authentication);
	 * 
	 * OAuth2AccessToken token =
	 * authorizationServerTokenServices.createAccessToken(auth2Authentication);
	 * 
	 * response.setContentType("application/json;charset-UTF-8");
	 * response.getWriter().write(objectMapper.writeValueAsString(token)); }
	 */

}
