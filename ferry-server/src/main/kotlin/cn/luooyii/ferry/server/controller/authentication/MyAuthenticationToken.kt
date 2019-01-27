package cn.luooyii.ferry.server.controller.authentication

import org.springframework.security.authentication.AbstractAuthenticationToken
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.SpringSecurityCoreVersion

class MyAuthenticationToken : AbstractAuthenticationToken {

    // ~ Instance fields
    // ================================================================================================

    private val principal: Any

    // ~ Constructors
    // ===================================================================================================

    /**
     * This constructor can be safely used by any code that wishes to create a
     * `UsernamePasswordAuthenticationToken`, as the [.isAuthenticated]
     * will return `false`.
     *
     */
    constructor(principal: String) : super(null) {
        this.principal = principal
        isAuthenticated = false
    }

    /**
     * This constructor should only be used by `AuthenticationManager` or
     * `AuthenticationProvider` implementations that are satisfied with
     * producing a trusted (i.e. [.isAuthenticated] = `true`)
     * authentication token.
     *
     * @param principal
     * @param authorities
     */
    constructor(principal: Any,
                authorities: Collection<GrantedAuthority>) : super(authorities) {
        this.principal = principal
        super.setAuthenticated(true) // must use super, as we override
    }

    // ~ Methods
    // ========================================================================================================

    override fun getCredentials(): Any? {
        return null
    }

    override fun getPrincipal(): Any {
        return this.principal
    }

    @Throws(IllegalArgumentException::class)
    override fun setAuthenticated(isAuthenticated: Boolean) {
        if (isAuthenticated) {
            throw IllegalArgumentException(
                    "Cannot set this token to trusted - use constructor which takes a GrantedAuthority list instead")
        }

        super.setAuthenticated(false)
    }

    override fun eraseCredentials() {
        super.eraseCredentials()
    }

    companion object {

        private val serialVersionUID = SpringSecurityCoreVersion.SERIAL_VERSION_UID
    }
}
