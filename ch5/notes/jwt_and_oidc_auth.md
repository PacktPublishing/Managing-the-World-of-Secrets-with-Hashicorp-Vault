# JWT
- Authentication flow for "jwt" roles is simpler than OIDC Vault just validates the JWT.
- 3 ways to do it. Configure one of them per backend:

## Static Keys
Keys directly stored in backend config, aka secrets under the specific path

## JWKS JSON Web Key Set URL
- Keys fetched from ths endpoint (URL) during authentication
- (Optional) Certificate chain

## OIDC Discovery URL
- Also an endpoint
- Difference compared to JWKS OIDC validation criteria used, e.g. iss, aud
    iss short for issuer; a "claim" in the JWT
    aud short for audience; the recipients this JWT is intended for; who gets it, in order to use it for authorization
- (Optional) Certificate chain

<span style="color:red">!!!</span> 
For many method instances mount JWT auth method at different paths.

# OIDC
## Decoding a JWT from the command line
```sh
JWT=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ

jqR 'split(".") | .[1] | @base64d | fromjson' <<< "$JWT"
```