package cn.luooyii.ferry.server.utils

import org.springframework.web.multipart.MultipartFile

import java.io.*
import java.net.URL
import java.util.UUID

object ImageUtil {

    /**
     * 保存文件，直接以multipartFile形式
     *
     * @param multipartFile
     * @param path
     * 文件保存绝对路径
     * @return 返回文件名
     * @throws IOException
     */
    @Throws(IOException::class)
    fun saveImg(multipartFile: MultipartFile, path: String): String {
        val pictureFormat = multipartFile.originalFilename!!.substring(multipartFile.originalFilename!!.lastIndexOf(".") + 1)
        val file = File(path)
        if (!file.exists()) {
            file.mkdirs()
        }
        val fileInputStream = multipartFile.inputStream as FileInputStream
        val fileName = UUID.randomUUID().toString() + "." + pictureFormat
        val bos = BufferedOutputStream(FileOutputStream(path + File.separator + fileName))
        val bs = ByteArray(1024)
        var len: Int
        len = fileInputStream.read(bs)
        while (len != -1) {
            bos.write(bs, 0, len)
        }
        bos.flush()
        bos.close()
        return fileName
    }

    /**
     * 链接url保存图片
     * @param urlForString
     * @param path
     * @return
     * @throws IOException
     */
    @Throws(IOException::class)
    fun saveImg(urlForString: String, path: String): String {

        val file = File(path)
        if (!file.exists()) {
            file.mkdirs()
        }

        val url = URL(urlForString)
        val dataInputStream = DataInputStream(url.openStream())
        /* FileInputStream fileInputStream = (FileInputStream) url.openStream(); */
        val fileName = UUID.randomUUID().toString() + ".png"
        val bos = BufferedOutputStream(FileOutputStream(path + File.separator + fileName))

        val bs = ByteArray(1024)
        var len: Int
        len = dataInputStream.read(bs)
        while (len != -1) {
            bos.write(bs, 0, len)
        }
        bos.flush()
        bos.close()

        return fileName
    }

}
