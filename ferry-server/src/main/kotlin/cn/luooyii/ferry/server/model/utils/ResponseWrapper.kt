package cn.luooyii.ferry.server.model.utils

/**
 * 返回的JSON数据结构标准
 *
 * @param <T>
</T> */
class ResponseWrapper<T> {

    var status: String? = null

    var message: String? = null

    var data: T? = null

    constructor(status: String) {
        this.status = status
    }

    constructor(status: String, message: String) {
        this.status = status
        this.message = message
    }

    constructor(status: String, data: T) {
        this.status = status
        this.data = data
    }

    constructor(status: String, message: String, data: T) {
        this.status = status
        this.message = message
        this.data = data
    }
}
