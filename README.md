# botan

Low-level Haskell bindings for the Botan cryptography library

These are bindings to Botan's [low-level C89 FFI module](https://botan.randombit.net/handbook/api_ref/ffi.html), which should pair excellently with Haskell's own `CApiFFI` - see [here](https://downloads.haskell.org/ghc/9.0.1/docs/html/users_guide/exts/ffi.html?highlight=capiffi#extension-CApiFFI) for more details.

## Installing Botan

Botan 3 must be installed for this library to work.

> Botan is available already in nearly all [packaging systems](https://repology.org/project/botan/versions) so you probably only need to build from source if you need unusual options or are building for an old system which has out of date packages.
>
> - https://botan.randombit.net/handbook/building.html

### Windows

- TODO

### MacOS

Use homebrew: `brew install botan`

### Unix

See your appropriate package manager.

# TODO LIST

- Documentation / fix existing documentation
- Consistent / better nomenclature - get rid of explicit 'botan' except for a few explicit things
- Use [the actual headers](https://github.com/randombit/botan/blob/release-3/src/lib/ffi/ffi.h) because [the documentation is sometimes wrong / missing](https://botan.randombit.net/handbook/api_ref/ffi.html).
- Use `MonadIO m => m a` instead of `IO a` wherever possible.
- Use `Text` and ~~`ByteArray`~~ `ByteString`.
- `{-# INLINE #-}` and `{-# NOINLINE #-}`
- `{-# UNPACK #-}`
- `HasCallStack`
- https://downloads.haskell.org/ghc/9.0.1/docs/html/users_guide/exts/ffi.html?highlight=capiffi#memory-allocations
- Complete documentation
- `Botan.Prelude` and `NoImplicitPrelude`
- Fix using `Ptr x` for everything from `const uint8_t *in` to `uint8_t out[]`
    - See if there are specific types for this.
- `ScrubbedBytes` using `botan_scrub_mem`
- Discuss: Patterns vs constants - 
    - `pattern BOTAN_FFI_SUCCESS = 0 :: BotanErrorCode` vs `data BotanErrorCode = Success | ...`
    - Possibly use `*.hsc` and a `Botan.Constants` file.
- Discuss: Initializing foreign pointers
    - Old way: `opaqueForeignPtr <- alloca $ newForeignPtr botan_hash_destroy`
        - likely was causing exceptions
        - I used alloc when replacing ByteArray.alloc, but that actually uses `Bytestring.mallocByteString`
    - New way: `opaqueForeignPtr <- malloc >>= newForeignPtr botan_hash_destroy`
        - Switched to `malloc `, now mostly just looking for sanity check / confirmation that this was the correct thing to do.
- Consistency (in particular, `Random` is bad with `randomFoo :: Int -> foo -> result` vs `foo -> Int -> result`)
- Replace some `Ptr CChar` with `CString` as appropriate (when null-terminated).
- Reusing data types / constants between modules: eg, some `MacType` expect a `HashType` a la `HMAC SHA256` / `HMAC(SHA-256)`
- Conditional compilation / support checks for algorithms.
- Discuss ffi `unsafe` and destructors
    - I do not remember why I did not mark them as `unsafe` in the first place
    - After reading this, I am inclined to believe that it is fine for them to be `unsafe`.
        - https://frasertweedale.github.io/blog-fp/posts/2022-09-23-ffi-safety-and-gc.html
- Vanish `Text` and then only reintroduce after safely wrapping types (Text is just in the way right now)
- Examine copy-safety regarding `withBytes` and `ByteString.unsafeUseAs...`
    - Use the faster unsafe variants as applicable.
- The terminology of `ByteString.useAsCString` vs `CString.withCString`
    - We will use `asCString` and `asBytes` to avoid colliding nomenclature
    - Having implemented the `as-` helpers, they probably do some unnecessary copying
        - We've likey overreached on the safety vs speed aspect, re: unnecessary copying
- Some `CString` trailing `NUL` handling, eg: `macName m` yields `"HMAC(SHA-384)\NUL"`
- Use `CString` / `Text` for null-terminated strings, bytestrings otherwise.


# Issues

We should be trying to use `capi` instead of `ccall`, a la: 

https://wiki.haskell.org/Foreign_Function_Interface

However, this causes issues, eg:

```
error: call to undeclared function 'botan_version_string'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
--  warning: incompatible integer to pointer conversion returning 'int' from a function with result type 'char *' [-Wint-conversion]
```

Complicating things is (from the Foreign.ForeignPtr docs):

```
type FinalizerPtr a = FunPtr (Ptr a -> IO ())
-- ^ Note that the foreign function must use the ccall calling convention.
```

It is therefore possible that we must use `ccall`. Further investigation is needed.