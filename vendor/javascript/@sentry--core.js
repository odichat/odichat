// @sentry/core@9.17.0 downloaded from https://ga.jspm.io/npm:@sentry/core@9.17.0/build/esm/index.js

const t=typeof __SENTRY_DEBUG__==="undefined"||__SENTRY_DEBUG__;const e="9.17.0";const n=globalThis;function r(){s(n);return n}function s(t){const n=t.__SENTRY__=t.__SENTRY__||{};n.version=n.version||e;return n[e]=n[e]||{}}
/**
 * Returns a global singleton contained in the global `__SENTRY__[]` object.
 *
 * If the singleton doesn't already exist in `__SENTRY__`, it will be created using the given factory
 * function and added to the `__SENTRY__` object.
 *
 * @param name name of the global singleton on __SENTRY__
 * @param creator creator Factory function to create the singleton if it doesn't already exist on `__SENTRY__`
 * @param obj (Optional) The global object on which to look for `__SENTRY__`, if not `GLOBAL_OBJ`'s return value
 * @returns the singleton
 */function o(t,r,s=n){const o=s.__SENTRY__=s.__SENTRY__||{};const i=o[e]=o[e]||{};return i[t]||(i[t]=r())}const i=Object.prototype.toString;
/**
 * Checks whether given value's type is one of a few Error or Error-like
 * {@link isError}.
 *
 * @param wat A value to be checked.
 * @returns A boolean representing the result.
 */function a(t){switch(i.call(t)){case"[object Error]":case"[object Exception]":case"[object DOMException]":case"[object WebAssembly.Exception]":return true;default:return S(t,Error)}}
/**
 * Checks whether given value is an instance of the given built-in class.
 *
 * @param wat The value to be checked
 * @param className
 * @returns A boolean representing the result.
 */function c(t,e){return i.call(t)===`[object ${e}]`}
/**
 * Checks whether given value's type is ErrorEvent
 * {@link isErrorEvent}.
 *
 * @param wat A value to be checked.
 * @returns A boolean representing the result.
 */function u(t){return c(t,"ErrorEvent")}
/**
 * Checks whether given value's type is DOMError
 * {@link isDOMError}.
 *
 * @param wat A value to be checked.
 * @returns A boolean representing the result.
 */function l(t){return c(t,"DOMError")}
/**
 * Checks whether given value's type is DOMException
 * {@link isDOMException}.
 *
 * @param wat A value to be checked.
 * @returns A boolean representing the result.
 */function p(t){return c(t,"DOMException")}
/**
 * Checks whether given value's type is a string
 * {@link isString}.
 *
 * @param wat A value to be checked.
 * @returns A boolean representing the result.
 */function f(t){return c(t,"String")}
/**
 * Checks whether given string is parameterized
 * {@link isParameterizedString}.
 *
 * @param wat A value to be checked.
 * @returns A boolean representing the result.
 */function d(t){return typeof t==="object"&&t!==null&&"__sentry_template_string__"in t&&"__sentry_template_values__"in t}
/**
 * Checks whether given value is a primitive (undefined, null, number, boolean, string, bigint, symbol)
 * {@link isPrimitive}.
 *
 * @param wat A value to be checked.
 * @returns A boolean representing the result.
 */function h(t){return t===null||d(t)||typeof t!=="object"&&typeof t!=="function"}
/**
 * Checks whether given value's type is an object literal, or a class instance.
 * {@link isPlainObject}.
 *
 * @param wat A value to be checked.
 * @returns A boolean representing the result.
 */function m(t){return c(t,"Object")}
/**
 * Checks whether given value's type is an Event instance
 * {@link isEvent}.
 *
 * @param wat A value to be checked.
 * @returns A boolean representing the result.
 */function g(t){return typeof Event!=="undefined"&&S(t,Event)}
/**
 * Checks whether given value's type is an Element instance
 * {@link isElement}.
 *
 * @param wat A value to be checked.
 * @returns A boolean representing the result.
 */function _(t){return typeof Element!=="undefined"&&S(t,Element)}
/**
 * Checks whether given value's type is an regexp
 * {@link isRegExp}.
 *
 * @param wat A value to be checked.
 * @returns A boolean representing the result.
 */function y(t){return c(t,"RegExp")}
/**
 * Checks whether given value has a then function.
 * @param wat A value to be checked.
 */function v(t){return Boolean(t?.then&&typeof t.then==="function")}
/**
 * Checks whether given value's type is a SyntheticEvent
 * {@link isSyntheticEvent}.
 *
 * @param wat A value to be checked.
 * @returns A boolean representing the result.
 */function b(t){return m(t)&&"nativeEvent"in t&&"preventDefault"in t&&"stopPropagation"in t}
/**
 * Checks whether given value's type is an instance of provided constructor.
 * {@link isInstanceOf}.
 *
 * @param wat A value to be checked.
 * @param base A constructor to be used in a check.
 * @returns A boolean representing the result.
 */function S(t,e){try{return t instanceof e}catch(t){return false}}
/**
 * Checks whether given value's type is a Vue ViewModel.
 *
 * @param wat A value to be checked.
 * @returns A boolean representing the result.
 */function E(t){return!!(typeof t==="object"&&t!==null&&(t.__isVue||t._isVue))}function w(t){return typeof Request!=="undefined"&&S(t,Request)}const x=n;const k=80;
/**
 * Given a child DOM element, returns a query-selector statement describing that
 * and its ancestors
 * e.g. [HTMLElement] => body > div > input#foo.btn[name=baz]
 * @returns generated DOM path
 */function I(t,e={}){if(!t)return"<unknown>";try{let n=t;const r=5;const s=[];let o=0;let i=0;const a=" > ";const c=a.length;let u;const l=Array.isArray(e)?e:e.keyAttrs;const p=!Array.isArray(e)&&e.maxStringLength||k;while(n&&o++<r){u=$(n,l);if(u==="html"||o>1&&i+s.length*c+u.length>=p)break;s.push(u);i+=u.length;n=n.parentNode}return s.reverse().join(a)}catch(t){return"<unknown>"}}
/**
 * Returns a simple, query-selector representation of a DOM element
 * e.g. [HTMLElement] => input#foo.btn[name=baz]
 * @returns generated DOM path
 */function $(t,e){const n=t;const r=[];if(!n?.tagName)return"";if(x.HTMLElement&&n instanceof HTMLElement&&n.dataset){if(n.dataset.sentryComponent)return n.dataset.sentryComponent;if(n.dataset.sentryElement)return n.dataset.sentryElement}r.push(n.tagName.toLowerCase());const s=e?.length?e.filter((t=>n.getAttribute(t))).map((t=>[t,n.getAttribute(t)])):null;if(s?.length)s.forEach((t=>{r.push(`[${t[0]}="${t[1]}"]`)}));else{n.id&&r.push(`#${n.id}`);const t=n.className;if(t&&f(t)){const e=t.split(/\s+/);for(const t of e)r.push(`.${t}`)}}const o=["aria-label","type","name","title","alt"];for(const t of o){const e=n.getAttribute(t);e&&r.push(`[${t}="${e}"]`)}return r.join("")}function T(){try{return x.document.location.href}catch(t){return""}}
/**
 * Given a DOM element, traverses up the tree until it finds the first ancestor node
 * that has the `data-sentry-component` or `data-sentry-element` attribute with `data-sentry-component` taking
 * precedence. This attribute is added at build-time by projects that have the component name annotation plugin installed.
 *
 * @returns a string representation of the component for the provided DOM element, or `null` if not found
 */function A(t){if(!x.HTMLElement)return null;let e=t;const n=5;for(let t=0;t<n;t++){if(!e)return null;if(e instanceof HTMLElement){if(e.dataset.sentryComponent)return e.dataset.sentryComponent;if(e.dataset.sentryElement)return e.dataset.sentryElement}e=e.parentNode}return null}const O=typeof __SENTRY_DEBUG__==="undefined"||__SENTRY_DEBUG__;const C="Sentry Logger ";const P=["debug","info","warn","error","log","assert","trace"];const N={};
/**
 * Temporarily disable sentry console instrumentations.
 *
 * @param callback The function to run against the original `console` messages
 * @returns The results of the callback
 */function R(t){if(!("console"in n))return t();const e=n.console;const r={};const s=Object.keys(N);s.forEach((t=>{const n=N[t];r[t]=e[t];e[t]=n}));try{return t()}finally{s.forEach((t=>{e[t]=r[t]}))}}function D(){let t=false;const e={enable:()=>{t=true},disable:()=>{t=false},isEnabled:()=>t};O?P.forEach((r=>{e[r]=(...e)=>{t&&R((()=>{n.console[r](`${C}[${r}]:`,...e)}))}})):P.forEach((t=>{e[t]=()=>{}}));return e}const j=o("logger",D);
/**
 * Truncates given string to the maximum characters count
 *
 * @param str An object that contains serializable values
 * @param max Maximum number of characters in truncated string (0 = unlimited)
 * @returns string Encoded
 */function M(t,e=0){return typeof t!=="string"||e===0||t.length<=e?t:`${t.slice(0,e)}...`}
/**
 * This is basically just `trim_line` from
 * https://github.com/getsentry/sentry/blob/master/src/sentry/lang/javascript/processor.py#L67
 *
 * @param str An object that contains serializable values
 * @param max Maximum number of characters in truncated string
 * @returns string Encoded
 */function L(t,e){let n=t;const r=n.length;if(r<=150)return n;e>r&&(e=r);let s=Math.max(e-60,0);s<5&&(s=0);let o=Math.min(s+140,r);o>r-5&&(o=r);o===r&&(s=Math.max(o-140,0));n=n.slice(s,o);s>0&&(n=`'{snip} ${n}`);o<r&&(n+=" {snip}");return n}
/**
 * Join values in array
 * @param input array of values to be joined together
 * @param delimiter string to be placed in-between values
 * @returns Joined values
 */function F(t,e){if(!Array.isArray(t))return"";const n=[];for(let e=0;e<t.length;e++){const r=t[e];try{E(r)?n.push("[VueViewModel]"):n.push(String(r))}catch(t){n.push("[value cannot be serialized]")}}return n.join(e)}
/**
 * Checks if the given value matches a regex or string
 *
 * @param value The string to test
 * @param pattern Either a regex or a string against which `value` will be matched
 * @param requireExactStringMatch If true, `value` must match `pattern` exactly. If false, `value` will match
 * `pattern` if it contains `pattern`. Only applies to string-type patterns.
 */function U(t,e,n=false){return!!f(t)&&(y(e)?e.test(t):!!f(e)&&(n?t===e:t.includes(e)))}
/**
 * Test the given string against an array of strings and regexes. By default, string matching is done on a
 * substring-inclusion basis rather than a strict equality basis
 *
 * @param testString The string to test
 * @param patterns The patterns against which to test the string
 * @param requireExactStringMatch If true, `testString` must match one of the given string patterns exactly in order to
 * count. If false, `testString` will match a string pattern if it contains that pattern.
 * @returns
 */function z(t,e=[],n=false){return e.some((e=>U(t,e,n)))}
/**
 * Replace a method in an object with a wrapped version of itself.
 *
 * If the method on the passed object is not a function, the wrapper will not be applied.
 *
 * @param source An object that contains a method to be wrapped.
 * @param name The name of the method to be wrapped.
 * @param replacementFactory A higher-order function that takes the original version of the given method and returns a
 * wrapped version. Note: The function returned by `replacementFactory` needs to be a non-arrow function, in order to
 * preserve the correct value of `this`, and the original method must be called using `origMethod.call(this, <other
 * args>)` or `origMethod.apply(this, [<other args>])` (rather than being called directly), again to preserve `this`.
 * @returns void
 */function q(t,e,n){if(!(e in t))return;const r=t[e];if(typeof r!=="function")return;const s=n(r);typeof s==="function"&&W(s,r);try{t[e]=s}catch{O&&j.log(`Failed to replace method "${e}" in object`,t)}}
/**
 * Defines a non-enumerable property on the given object.
 *
 * @param obj The object on which to set the property
 * @param name The name of the property to be set
 * @param value The value to which to set the property
 */function B(t,e,n){try{Object.defineProperty(t,e,{value:n,writable:true,configurable:true})}catch(n){O&&j.log(`Failed to add non-enumerable property "${e}" to object`,t)}}
/**
 * Remembers the original function on the wrapped function and
 * patches up the prototype.
 *
 * @param wrapped the wrapper function
 * @param original the original function that gets wrapped
 */function W(t,e){try{const n=e.prototype||{};t.prototype=e.prototype=n;B(t,"__sentry_original__",e)}catch(t){}}
/**
 * This extracts the original function if available.  See
 * `markFunctionWrapped` for more information.
 *
 * @param func the function to unwrap
 * @returns the unwrapped version of the function if available.
 */function J(t){return t.__sentry_original__}
/**
 * Transforms any `Error` or `Event` into a plain object with all of their enumerable properties, and some of their
 * non-enumerable properties attached.
 *
 * @param value Initial source that we have to transform in order for it to be usable by the serializer
 * @returns An Event or Error turned into an object - or the value argument itself, when value is neither an Event nor
 *  an Error.
 */function G(t){if(a(t))return{message:t.message,name:t.name,stack:t.stack,...H(t)};if(g(t)){const e={type:t.type,target:Z(t.target),currentTarget:Z(t.currentTarget),...H(t)};typeof CustomEvent!=="undefined"&&S(t,CustomEvent)&&(e.detail=t.detail);return e}return t}function Z(t){try{return _(t)?I(t):Object.prototype.toString.call(t)}catch(t){return"<unknown>"}}function H(t){if(typeof t==="object"&&t!==null){const e={};for(const n in t)Object.prototype.hasOwnProperty.call(t,n)&&(e[n]=t[n]);return e}return{}}function Y(t,e=40){const n=Object.keys(G(t));n.sort();const r=n[0];if(!r)return"[object has no keys]";if(r.length>=e)return M(r,e);for(let t=n.length;t>0;t--){const r=n.slice(0,t).join(", ");if(!(r.length>e))return t===n.length?r:M(r,e)}return""}
/**
 * Given any object, return a new object having removed all fields whose value was `undefined`.
 * Works recursively on objects and arrays.
 *
 * Attention: This function keeps circular references in the returned object.
 *
 * @deprecated This function is no longer used by the SDK and will be removed in a future major version.
 */function K(t){const e=new Map;return V(t,e)}function V(t,e){if(t===null||typeof t!=="object")return t;const n=e.get(t);if(n!==void 0)return n;if(Array.isArray(t)){const n=[];e.set(t,n);t.forEach((t=>{n.push(V(t,e))}));return n}if(X(t)){const n={};e.set(t,n);const r=Object.keys(t);r.forEach((r=>{const s=t[r];s!==void 0&&(n[r]=V(s,e))}));return n}return t}function X(t){const e=t.constructor;return e===Object||e===void 0}
/**
 * Ensure that something is an object.
 *
 * Turns `undefined` and `null` into `String`s and all other primitives into instances of their respective wrapper
 * classes (String, Boolean, Number, etc.). Acts as the identity function on non-primitives.
 *
 * @param wat The subject of the objectification
 * @returns A version of `wat` which can safely be used with `Object` class methods
 */function Q(t){let e;switch(true){case t==void 0:e=new String(t);break;case typeof t==="symbol"||typeof t==="bigint":e=Object(t);break;case h(t):e=new t.constructor(t);break;default:e=t;break}return e}function tt(){const t=n;return t.crypto||t.msCrypto}
/**
 * UUID4 generator
 * @param crypto Object that provides the crypto API.
 * @returns string Generated UUID4.
 */function et(t=tt()){let e=()=>Math.random()*16;try{if(t?.randomUUID)return t.randomUUID().replace(/-/g,"");t?.getRandomValues&&(e=()=>{const e=new Uint8Array(1);t.getRandomValues(e);return e[0]})}catch(t){}return([1e7]+1e3+4e3+8e3+1e11).replace(/[018]/g,(t=>(t^(e()&15)>>t/4).toString(16)))}function nt(t){return t.exception?.values?.[0]}
/**
 * Extracts either message or type+value from an event that can be used for user-facing logs
 * @returns event's description
 */function rt(t){const{message:e,event_id:n}=t;if(e)return e;const r=nt(t);return r?r.type&&r.value?`${r.type}: ${r.value}`:r.type||r.value||n||"<unknown>":n||"<unknown>"}
/**
 * Adds exception values, type and value to an synthetic Exception.
 * @param event The event to modify.
 * @param value Value of the exception.
 * @param type Type of the exception.
 * @hidden
 */function st(t,e,n){const r=t.exception=t.exception||{};const s=r.values=r.values||[];const o=s[0]=s[0]||{};o.value||(o.value=e||"");o.type||(o.type=n||"Error")}
/**
 * Adds exception mechanism data to a given event. Uses defaults if the second parameter is not passed.
 *
 * @param event The event to modify.
 * @param newMechanism Mechanism data to add to the event.
 * @hidden
 */function ot(t,e){const n=nt(t);if(!n)return;const r={type:"generic",handled:true};const s=n.mechanism;n.mechanism={...r,...s,...e};if(e&&"data"in e){const t={...s?.data,...e.data};n.mechanism.data=t}}const it=/^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$/;function at(t){return parseInt(t||"",10)}
/**
 * Parses input into a SemVer interface
 * @param input string representation of a semver version
 */function ct(t){const e=t.match(it)||[];const n=at(e[1]);const r=at(e[2]);const s=at(e[3]);return{buildmetadata:e[5],major:isNaN(n)?void 0:n,minor:isNaN(r)?void 0:r,patch:isNaN(s)?void 0:s,prerelease:e[4]}}
/**
 * This function adds context (pre/post/line) lines to the provided frame
 *
 * @param lines string[] containing all lines
 * @param frame StackFrame that will be mutated
 * @param linesOfContext number of context lines we want to add pre/post
 */function ut(t,e,n=5){if(e.lineno===void 0)return;const r=t.length;const s=Math.max(Math.min(r-1,e.lineno-1),0);e.pre_context=t.slice(Math.max(0,s-n),s).map((t=>L(t,0)));const o=Math.min(r-1,s);e.context_line=L(t[o],e.colno||0);e.post_context=t.slice(Math.min(s+1,r),s+1+n).map((t=>L(t,0)))}
/**
 * Checks whether or not we've already captured the given exception (note: not an identical exception - the very object
 * in question), and marks it captured if not.
 *
 * This is useful because it's possible for an error to get captured by more than one mechanism. After we intercept and
 * record an error, we rethrow it (assuming we've intercepted it before it's reached the top-level global handlers), so
 * that we don't interfere with whatever effects the error might have had were the SDK not there. At that point, because
 * the error has been rethrown, it's possible for it to bubble up to some other code we've instrumented. If it's not
 * caught after that, it will bubble all the way up to the global handlers (which of course we also instrument). This
 * function helps us ensure that even if we encounter the same error more than once, we only record it the first time we
 * see it.
 *
 * Note: It will ignore primitives (always return `false` and not mark them as seen), as properties can't be set on
 * them. {@link: Object.objectify} can be used on exceptions to convert any that are primitives into their equivalent
 * object wrapper forms so that this check will always work. However, because we need to flag the exact object which
 * will get rethrown, and because that rethrowing happens outside of the event processing pipeline, the objectification
 * must be done before the exception captured.
 *
 * @param A thrown exception to check or flag as having been seen
 * @returns `true` if the exception has already been captured, `false` if not (with the side effect of marking it seen)
 */function lt(t){if(pt(t))return true;try{B(t,"__sentry_captured__",true)}catch(t){}return false}function pt(t){try{return t.__sentry_captured__}catch{}}const ft=1e3;function dt(){return Date.now()/ft}function ht(){const{performance:t}=n;if(!t?.now)return dt;const e=Date.now()-t.now();const r=t.timeOrigin==void 0?e:t.timeOrigin;return()=>(r+t.now())/ft}const mt=ht();let gt;function _t(){const{performance:t}=n;if(!t?.now)return[void 0,"none"];const e=36e5;const r=t.now();const s=Date.now();const o=t.timeOrigin?Math.abs(t.timeOrigin+r-s):e;const i=o<e;const a=t.timing?.navigationStart;const c=typeof a==="number";const u=c?Math.abs(a+r-s):e;const l=u<e;return i||l?o<=u?[t.timeOrigin,"timeOrigin"]:[a,"navigationStart"]:[s,"dateNow"]}function yt(){gt||(gt=_t());return gt[0]}
/**
 * Creates a new `Session` object by setting certain default parameters. If optional @param context
 * is passed, the passed properties are applied to the session object.
 *
 * @param context (optional) additional properties to be applied to the returned session object
 *
 * @returns a new `Session` object
 */function vt(t){const e=mt();const n={sid:et(),init:true,timestamp:e,started:e,duration:0,status:"ok",errors:0,ignoreDuration:false,toJSON:()=>Et(n)};t&&bt(n,t);return n}
/**
 * Updates a session object with the properties passed in the context.
 *
 * Note that this function mutates the passed object and returns void.
 * (Had to do this instead of returning a new and updated session because closing and sending a session
 * makes an update to the session after it was passed to the sending logic.
 * @see Client.captureSession )
 *
 * @param session the `Session` to update
 * @param context the `SessionContext` holding the properties that should be updated in @param session
 */function bt(t,e={}){if(e.user){!t.ipAddress&&e.user.ip_address&&(t.ipAddress=e.user.ip_address);t.did||e.did||(t.did=e.user.id||e.user.email||e.user.username)}t.timestamp=e.timestamp||mt();e.abnormal_mechanism&&(t.abnormal_mechanism=e.abnormal_mechanism);e.ignoreDuration&&(t.ignoreDuration=e.ignoreDuration);e.sid&&(t.sid=e.sid.length===32?e.sid:et());e.init!==void 0&&(t.init=e.init);!t.did&&e.did&&(t.did=`${e.did}`);typeof e.started==="number"&&(t.started=e.started);if(t.ignoreDuration)t.duration=void 0;else if(typeof e.duration==="number")t.duration=e.duration;else{const e=t.timestamp-t.started;t.duration=e>=0?e:0}e.release&&(t.release=e.release);e.environment&&(t.environment=e.environment);!t.ipAddress&&e.ipAddress&&(t.ipAddress=e.ipAddress);!t.userAgent&&e.userAgent&&(t.userAgent=e.userAgent);typeof e.errors==="number"&&(t.errors=e.errors);e.status&&(t.status=e.status)}
/**
 * Closes a session by setting its status and updating the session object with it.
 * Internally calls `updateSession` to update the passed session object.
 *
 * Note that this function mutates the passed session (@see updateSession for explanation).
 *
 * @param session the `Session` object to be closed
 * @param status the `SessionStatus` with which the session was closed. If you don't pass a status,
 *               this function will keep the previously set status, unless it was `'ok'` in which case
 *               it is changed to `'exited'`.
 */function St(t,e){let n={};e?n={status:e}:t.status==="ok"&&(n={status:"exited"});bt(t,n)}
/**
 * Serializes a passed session object to a JSON object with a slightly different structure.
 * This is necessary because the Sentry backend requires a slightly different schema of a session
 * than the one the JS SDKs use internally.
 *
 * @param session the session to be converted
 *
 * @returns a JSON object of the passed session
 */function Et(t){return{sid:`${t.sid}`,init:t.init,started:new Date(t.started*1e3).toISOString(),timestamp:new Date(t.timestamp*1e3).toISOString(),status:t.status,errors:t.errors,did:typeof t.did==="number"||typeof t.did==="string"?`${t.did}`:void 0,duration:t.duration,abnormal_mechanism:t.abnormal_mechanism,attrs:{release:t.release,environment:t.environment,ip_address:t.ipAddress,user_agent:t.userAgent}}}function wt(t,e,n=2){if(!e||typeof e!=="object"||n<=0)return e;if(t&&Object.keys(e).length===0)return t;const r={...t};for(const t in e)Object.prototype.hasOwnProperty.call(e,t)&&(r[t]=wt(r[t],e[t],n-1));return r}const xt="_sentrySpan";function kt(t,e){e?B(t,xt,e):delete t[xt]}function It(t){return t[xt]}function $t(){return et()}function Tt(){return et().substring(16)}const At=100;class Scope{constructor(){this._notifyingListeners=false;this._scopeListeners=[];this._eventProcessors=[];this._breadcrumbs=[];this._attachments=[];this._user={};this._tags={};this._extra={};this._contexts={};this._sdkProcessingMetadata={};this._propagationContext={traceId:$t(),sampleRand:Math.random()}}clone(){const t=new Scope;t._breadcrumbs=[...this._breadcrumbs];t._tags={...this._tags};t._extra={...this._extra};t._contexts={...this._contexts};this._contexts.flags&&(t._contexts.flags={values:[...this._contexts.flags.values]});t._user=this._user;t._level=this._level;t._session=this._session;t._transactionName=this._transactionName;t._fingerprint=this._fingerprint;t._eventProcessors=[...this._eventProcessors];t._attachments=[...this._attachments];t._sdkProcessingMetadata={...this._sdkProcessingMetadata};t._propagationContext={...this._propagationContext};t._client=this._client;t._lastEventId=this._lastEventId;kt(t,It(this));return t}setClient(t){this._client=t}setLastEventId(t){this._lastEventId=t}getClient(){return this._client}lastEventId(){return this._lastEventId}addScopeListener(t){this._scopeListeners.push(t)}addEventProcessor(t){this._eventProcessors.push(t);return this}setUser(t){this._user=t||{email:void 0,id:void 0,ip_address:void 0,username:void 0};this._session&&bt(this._session,{user:t});this._notifyScopeListeners();return this}getUser(){return this._user}setTags(t){this._tags={...this._tags,...t};this._notifyScopeListeners();return this}setTag(t,e){this._tags={...this._tags,[t]:e};this._notifyScopeListeners();return this}setExtras(t){this._extra={...this._extra,...t};this._notifyScopeListeners();return this}setExtra(t,e){this._extra={...this._extra,[t]:e};this._notifyScopeListeners();return this}
/**
   * Sets the fingerprint on the scope to send with the events.
   * @param {string[]} fingerprint Fingerprint to group events in Sentry.
   */setFingerprint(t){this._fingerprint=t;this._notifyScopeListeners();return this}setLevel(t){this._level=t;this._notifyScopeListeners();return this}setTransactionName(t){this._transactionName=t;this._notifyScopeListeners();return this}setContext(t,e){e===null?delete this._contexts[t]:this._contexts[t]=e;this._notifyScopeListeners();return this}setSession(t){t?this._session=t:delete this._session;this._notifyScopeListeners();return this}getSession(){return this._session}update(t){if(!t)return this;const e=typeof t==="function"?t(this):t;const n=e instanceof Scope?e.getScopeData():m(e)?t:void 0;const{tags:r,extra:s,user:o,contexts:i,level:a,fingerprint:c=[],propagationContext:u}=n||{};this._tags={...this._tags,...r};this._extra={...this._extra,...s};this._contexts={...this._contexts,...i};o&&Object.keys(o).length&&(this._user=o);a&&(this._level=a);c.length&&(this._fingerprint=c);u&&(this._propagationContext=u);return this}clear(){this._breadcrumbs=[];this._tags={};this._extra={};this._user={};this._contexts={};this._level=void 0;this._transactionName=void 0;this._fingerprint=void 0;this._session=void 0;kt(this,void 0);this._attachments=[];this.setPropagationContext({traceId:$t(),sampleRand:Math.random()});this._notifyScopeListeners();return this}addBreadcrumb(t,e){const n=typeof e==="number"?e:At;if(n<=0)return this;const r={timestamp:dt(),...t,message:t.message?M(t.message,2048):t.message};this._breadcrumbs.push(r);if(this._breadcrumbs.length>n){this._breadcrumbs=this._breadcrumbs.slice(-n);this._client?.recordDroppedEvent("buffer_overflow","log_item")}this._notifyScopeListeners();return this}getLastBreadcrumb(){return this._breadcrumbs[this._breadcrumbs.length-1]}clearBreadcrumbs(){this._breadcrumbs=[];this._notifyScopeListeners();return this}addAttachment(t){this._attachments.push(t);return this}clearAttachments(){this._attachments=[];return this}getScopeData(){return{breadcrumbs:this._breadcrumbs,attachments:this._attachments,contexts:this._contexts,tags:this._tags,extra:this._extra,user:this._user,level:this._level,fingerprint:this._fingerprint||[],eventProcessors:this._eventProcessors,propagationContext:this._propagationContext,sdkProcessingMetadata:this._sdkProcessingMetadata,transactionName:this._transactionName,span:It(this)}}setSDKProcessingMetadata(t){this._sdkProcessingMetadata=wt(this._sdkProcessingMetadata,t,2);return this}setPropagationContext(t){this._propagationContext=t;return this}getPropagationContext(){return this._propagationContext}
/**
   * Capture an exception for this scope.
   *
   * @returns {string} The id of the captured Sentry event.
   */captureException(t,e){const n=e?.event_id||et();if(!this._client){j.warn("No client configured on scope - will not capture exception!");return n}const r=new Error("Sentry syntheticException");this._client.captureException(t,{originalException:t,syntheticException:r,...e,event_id:n},this);return n}
/**
   * Capture a message for this scope.
   *
   * @returns {string} The id of the captured message.
   */captureMessage(t,e,n){const r=n?.event_id||et();if(!this._client){j.warn("No client configured on scope - will not capture message!");return r}const s=new Error(t);this._client.captureMessage(t,e,{originalException:t,syntheticException:s,...n,event_id:r},this);return r}
/**
   * Capture a Sentry event for this scope.
   *
   * @returns {string} The id of the captured event.
   */captureEvent(t,e){const n=e?.event_id||et();if(!this._client){j.warn("No client configured on scope - will not capture event!");return n}this._client.captureEvent(t,{...e,event_id:n},this);return n}_notifyScopeListeners(){if(!this._notifyingListeners){this._notifyingListeners=true;this._scopeListeners.forEach((t=>{t(this)}));this._notifyingListeners=false}}}function Ot(){return o("defaultCurrentScope",(()=>new Scope))}function Ct(){return o("defaultIsolationScope",(()=>new Scope))}class AsyncContextStack{constructor(t,e){let n;n=t||new Scope;let r;r=e||new Scope;this._stack=[{scope:n}];this._isolationScope=r}withScope(t){const e=this._pushScope();let n;try{n=t(e)}catch(t){this._popScope();throw t}if(v(n))return n.then((t=>{this._popScope();return t}),(t=>{this._popScope();throw t}));this._popScope();return n}getClient(){return this.getStackTop().client}getScope(){return this.getStackTop().scope}getIsolationScope(){return this._isolationScope}getStackTop(){return this._stack[this._stack.length-1]}_pushScope(){const t=this.getScope().clone();this._stack.push({client:this.getClient(),scope:t});return t}_popScope(){return!(this._stack.length<=1)&&!!this._stack.pop()}}function Pt(){const t=r();const e=s(t);return e.stack=e.stack||new AsyncContextStack(Ot(),Ct())}function Nt(t){return Pt().withScope(t)}function Rt(t,e){const n=Pt();return n.withScope((()=>{n.getStackTop().scope=t;return e(t)}))}function Dt(t){return Pt().withScope((()=>t(Pt().getIsolationScope())))}function jt(){return{withIsolationScope:Dt,withScope:Nt,withSetScope:Rt,withSetIsolationScope:(t,e)=>Dt(e),getCurrentScope:()=>Pt().getScope(),getIsolationScope:()=>Pt().getIsolationScope()}}function Mt(t){const e=r();const n=s(e);n.acs=t}function Lt(t){const e=s(t);return e.acs?e.acs:jt()}function Ft(){const t=r();const e=Lt(t);return e.getCurrentScope()}function Ut(){const t=r();const e=Lt(t);return e.getIsolationScope()}function zt(){return o("globalScope",(()=>new Scope))}function qt(...t){const e=r();const n=Lt(e);if(t.length===2){const[e,r]=t;return e?n.withSetScope(e,r):n.withScope(r)}return n.withScope(t[0])}function Bt(...t){const e=r();const n=Lt(e);if(t.length===2){const[e,r]=t;return e?n.withSetIsolationScope(e,r):n.withIsolationScope(r)}return n.withIsolationScope(t[0])}function Wt(){return Ft().getClient()}function Jt(t){const e=t.getPropagationContext();const{traceId:n,parentSpanId:r,propagationSpanId:s}=e;const o={trace_id:n,span_id:s||Tt()};r&&(o.parent_span_id=r);return o}const Gt="sentry.source";const Zt="sentry.sample_rate";const Ht="sentry.previous_trace_sample_rate";const Yt="sentry.op";const Kt="sentry.origin";const Vt="sentry.idle_span_finish_reason";const Xt="sentry.measurement_unit";const Qt="sentry.measurement_value";const te="sentry.custom_span_name";const ee="sentry.profile_id";const ne="sentry.exclusive_time";const re="cache.hit";const se="cache.key";const oe="cache.item_size";const ie="http.request.method";const ae="url.full";const ce="sentry.link.type";const ue=0;const le=1;const pe=2;
/**
 * Converts a HTTP status code into a sentry status with a message.
 *
 * @param httpStatus The HTTP response status code.
 * @returns The span status or unknown_error.
 */function fe(t){if(t<400&&t>=100)return{code:le};if(t>=400&&t<500)switch(t){case 401:return{code:pe,message:"unauthenticated"};case 403:return{code:pe,message:"permission_denied"};case 404:return{code:pe,message:"not_found"};case 409:return{code:pe,message:"already_exists"};case 413:return{code:pe,message:"failed_precondition"};case 429:return{code:pe,message:"resource_exhausted"};case 499:return{code:pe,message:"cancelled"};default:return{code:pe,message:"invalid_argument"}}if(t>=500&&t<600)switch(t){case 501:return{code:pe,message:"unimplemented"};case 503:return{code:pe,message:"unavailable"};case 504:return{code:pe,message:"deadline_exceeded"};default:return{code:pe,message:"internal_error"}}return{code:pe,message:"unknown_error"}}function de(t,e){t.setAttribute("http.response.status_code",e);const n=fe(e);n.message!=="unknown_error"&&t.setStatus(n)}const he="_sentryScope";const me="_sentryIsolationScope";function ge(t,e,n){if(t){B(t,me,n);B(t,he,e)}}function _e(t){return{scope:t[he],isolationScope:t[me]}}function ye(t){if(typeof t==="boolean")return Number(t);const e=typeof t==="string"?parseFloat(t):t;return typeof e!=="number"||isNaN(e)||e<0||e>1?void 0:e}const ve="sentry-";const be=/^sentry-/;const Se=8192;
/**
 * Takes a baggage header and turns it into Dynamic Sampling Context, by extracting all the "sentry-" prefixed values
 * from it.
 *
 * @param baggageHeader A very bread definition of a baggage header as it might appear in various frameworks.
 * @returns The Dynamic Sampling Context that was found on `baggageHeader`, if there was any, `undefined` otherwise.
 */function Ee(t){const e=xe(t);if(!e)return;const n=Object.entries(e).reduce(((t,[e,n])=>{if(e.match(be)){const r=e.slice(ve.length);t[r]=n}return t}),{});return Object.keys(n).length>0?n:void 0}
/**
 * Turns a Dynamic Sampling Object into a baggage header by prefixing all the keys on the object with "sentry-".
 *
 * @param dynamicSamplingContext The Dynamic Sampling Context to turn into a header. For convenience and compatibility
 * with the `getDynamicSamplingContext` method on the Transaction class ,this argument can also be `undefined`. If it is
 * `undefined` the function will return `undefined`.
 * @returns a baggage header, created from `dynamicSamplingContext`, or `undefined` either if `dynamicSamplingContext`
 * was `undefined`, or if `dynamicSamplingContext` didn't contain any values.
 */function we(t){if(!t)return;const e=Object.entries(t).reduce(((t,[e,n])=>{n&&(t[`${ve}${e}`]=n);return t}),{});return Ie(e)}function xe(t){if(t&&(f(t)||Array.isArray(t)))return Array.isArray(t)?t.reduce(((t,e)=>{const n=ke(e);Object.entries(n).forEach((([e,n])=>{t[e]=n}));return t}),{}):ke(t)}
/**
 * Will parse a baggage header, which is a simple key-value map, into a flat object.
 *
 * @param baggageHeader The baggage header to parse.
 * @returns a flat object containing all the key-value pairs from `baggageHeader`.
 */function ke(t){return t.split(",").map((t=>t.split("=").map((t=>decodeURIComponent(t.trim()))))).reduce(((t,[e,n])=>{e&&n&&(t[e]=n);return t}),{})}
/**
 * Turns a flat object (key-value pairs) into a baggage header, which is also just key-value pairs.
 *
 * @param object The object to turn into a baggage header.
 * @returns a baggage header string, or `undefined` if the object didn't have any values, since an empty baggage header
 * is not spec compliant.
 */function Ie(t){if(Object.keys(t).length!==0)return Object.entries(t).reduce(((t,[e,n],r)=>{const s=`${encodeURIComponent(e)}=${encodeURIComponent(n)}`;const o=r===0?s:`${t},${s}`;if(o.length>Se){O&&j.warn(`Not adding key: ${e} with val: ${n} to baggage header due to exceeding baggage size limits.`);return t}return o}),"")}const $e=new RegExp("^[ \\t]*([0-9a-f]{32})?-?([0-9a-f]{16})?-?([01])?[ \\t]*$");
/**
 * Extract transaction context data from a `sentry-trace` header.
 *
 * @param traceparent Traceparent string
 *
 * @returns Object containing data from the header, or undefined if traceparent string is malformed
 */function Te(t){if(!t)return;const e=t.match($e);if(!e)return;let n;e[3]==="1"?n=true:e[3]==="0"&&(n=false);return{traceId:e[1],parentSampled:n,parentSpanId:e[2]}}function Ae(t,e){const n=Te(t);const r=Ee(e);if(!n?.traceId)return{traceId:$t(),sampleRand:Math.random()};const s=Ce(n,r);r&&(r.sample_rand=s.toString());const{traceId:o,parentSpanId:i,parentSampled:a}=n;return{traceId:o,parentSpanId:i,sampled:a,dsc:r||{},sampleRand:s}}function Oe(t=$t(),e=Tt(),n){let r="";n!==void 0&&(r=n?"-1":"-0");return`${t}-${e}${r}`}function Ce(t,e){const n=ye(e?.sample_rand);if(n!==void 0)return n;const r=ye(e?.sample_rate);return r&&t?.parentSampled!==void 0?t.parentSampled?Math.random()*r:r+Math.random()*(1-r):Math.random()}const Pe=0;const Ne=1;let Re=false;function De(t){const{spanId:e,traceId:n}=t.spanContext();const{data:r,op:s,parent_span_id:o,status:i,origin:a,links:c}=ze(t);return{parent_span_id:o,span_id:e,trace_id:n,data:r,op:s,status:i,origin:a,links:c}}function je(t){const{spanId:e,traceId:n,isRemote:r}=t.spanContext();const s=r?e:ze(t).parent_span_id;const o=_e(t).scope;const i=r?o?.getPropagationContext().propagationSpanId||Tt():e;return{parent_span_id:s,span_id:i,trace_id:n}}function Me(t){const{traceId:e,spanId:n}=t.spanContext();const r=We(t);return Oe(e,n,r)}function Le(t){return t&&t.length>0?t.map((({context:{spanId:t,traceId:e,traceFlags:n,...r},attributes:s})=>({span_id:t,trace_id:e,sampled:n===Ne,attributes:s,...r}))):void 0}function Fe(t){return typeof t==="number"?Ue(t):Array.isArray(t)?t[0]+t[1]/1e9:t instanceof Date?Ue(t.getTime()):mt()}function Ue(t){const e=t>9999999999;return e?t/1e3:t}function ze(t){if(Be(t))return t.getSpanJSON();const{spanId:e,traceId:n}=t.spanContext();if(qe(t)){const{attributes:r,startTime:s,name:o,endTime:i,parentSpanId:a,status:c,links:u}=t;return{span_id:e,trace_id:n,data:r,description:o,parent_span_id:a,start_timestamp:Fe(s),timestamp:Fe(i)||void 0,status:Je(c),op:r[Yt],origin:r[Kt],links:Le(u)}}return{span_id:e,trace_id:n,start_timestamp:0,data:{}}}function qe(t){const e=t;return!!e.attributes&&!!e.startTime&&!!e.name&&!!e.endTime&&!!e.status}function Be(t){return typeof t.getSpanJSON==="function"}function We(t){const{traceFlags:e}=t.spanContext();return e===Ne}function Je(t){if(t&&t.code!==ue)return t.code===le?"ok":t.message||"unknown_error"}const Ge="_sentryChildSpans";const Ze="_sentryRootSpan";function He(t,e){const n=t[Ze]||t;B(e,Ze,n);t[Ge]?t[Ge].add(e):B(t,Ge,new Set([e]))}function Ye(t,e){t[Ge]&&t[Ge].delete(e)}function Ke(t){const e=new Set;function n(t){if(!e.has(t)&&We(t)){e.add(t);const r=t[Ge]?Array.from(t[Ge]):[];for(const t of r)n(t)}}n(t);return Array.from(e)}function Ve(t){return t[Ze]||t}function Xe(){const t=r();const e=Lt(t);return e.getActiveSpan?e.getActiveSpan():It(Ft())}function Qe(){if(!Re){R((()=>{console.warn("[Sentry] Returning null from `beforeSendSpan` is disallowed. To drop certain spans, configure the respective integrations directly.")}));Re=true}}
/**
 * Updates the name of the given span and ensures that the span name is not
 * overwritten by the Sentry SDK.
 *
 * Use this function instead of `span.updateName()` if you want to make sure that
 * your name is kept. For some spans, for example root `http.server` spans the
 * Sentry SDK would otherwise overwrite the span name with a high-quality name
 * it infers when the span ends.
 *
 * Use this function in server code or when your span is started on the server
 * and on the client (browser). If you only update a span name on the client,
 * you can also use `span.updateName()` the SDK does not overwrite the name.
 *
 * @param span - The span to update the name of.
 * @param name - The name to set on the span.
 */function tn(t,e){t.updateName(e);t.setAttributes({[Gt]:"custom",[te]:e})}const en=50;const nn="?";const rn=/\(error: (.*)\)/;const sn=/captureMessage|captureException/;function on(...t){const e=t.sort(((t,e)=>t[0]-e[0])).map((t=>t[1]));return(t,n=0,r=0)=>{const s=[];const o=t.split("\n");for(let t=n;t<o.length;t++){const n=o[t];if(n.length>1024)continue;const i=rn.test(n)?n.replace(rn,"$1"):n;if(!i.match(/\S*Error: /)){for(const t of e){const e=t(i);if(e){s.push(e);break}}if(s.length>=en+r)break}}return cn(s.slice(r))}}function an(t){return Array.isArray(t)?on(...t):t}function cn(t){if(!t.length)return[];const e=Array.from(t);/sentryWrapped/.test(un(e).function||"")&&e.pop();e.reverse();if(sn.test(un(e).function||"")){e.pop();sn.test(un(e).function||"")&&e.pop()}return e.slice(0,en).map((t=>({...t,filename:t.filename||un(e).filename,function:t.function||nn})))}function un(t){return t[t.length-1]||{}}const ln="<anonymous>";function pn(t){try{return t&&typeof t==="function"&&t.name||ln}catch(t){return ln}}function fn(t){const e=t.exception;if(e){const t=[];try{e.values.forEach((e=>{e.stacktrace.frames&&t.push(...e.stacktrace.frames)}));return t}catch(t){return}}}const dn={};const hn={};function mn(t,e){dn[t]=dn[t]||[];dn[t].push(e)}function gn(){Object.keys(dn).forEach((t=>{dn[t]=void 0}))}function _n(t,e){if(!hn[t]){hn[t]=true;try{e()}catch(e){O&&j.error(`Error while instrumenting ${t}`,e)}}}function yn(t,e){const n=t&&dn[t];if(n)for(const r of n)try{r(e)}catch(e){O&&j.error(`Error while triggering instrumentation handler.\nType: ${t}\nName: ${pn(r)}\nError:`,e)}}let vn=null;function bn(t){const e="error";mn(e,t);_n(e,Sn)}function Sn(){vn=n.onerror;n.onerror=function(t,e,n,r,s){const o={column:r,error:s,line:n,msg:t,url:e};yn("error",o);return!!vn&&vn.apply(this,arguments)};n.onerror.__SENTRY_INSTRUMENTED__=true}let En=null;function wn(t){const e="unhandledrejection";mn(e,t);_n(e,xn)}function xn(){En=n.onunhandledrejection;n.onunhandledrejection=function(t){const e=t;yn("unhandledrejection",e);return!En||En.apply(this,arguments)};n.onunhandledrejection.__SENTRY_INSTRUMENTED__=true}let kn=false;function In(){if(!kn){kn=true;bn($n);wn($n)}}function $n(){const e=Xe();const n=e&&Ve(e);if(n){const e="internal_error";t&&j.log(`[Tracing] Root span: ${e} -> Global error occurred`);n.setStatus({code:pe,message:e})}}$n.tag="sentry_tracingErrorCallback";
/**
 * Determines if span recording is currently enabled.
 *
 * Spans are recorded when at least one of `tracesSampleRate` and `tracesSampler`
 * is defined in the SDK config. This function does not make any assumption about
 * sampling decisions, it only checks if the SDK is configured to record spans.
 *
 * Important: This function only determines if span recording is enabled. Trace
 * continuation and propagation is separately controlled and not covered by this function.
 * If this function returns `false`, traces can still be propagated (which is what
 * we refer to by "Tracing without Performance")
 * @see https://develop.sentry.dev/sdk/telemetry/traces/tracing-without-performance/
 *
 * @param maybeOptions An SDK options object to be passed to this function.
 * If this option is not provided, the function will use the current client's options.
 */function Tn(t){if(typeof __SENTRY_TRACING__==="boolean"&&!__SENTRY_TRACING__)return false;const e=t||Wt()?.getOptions();return!!e&&(e.tracesSampleRate!=null||!!e.tracesSampler)}
/**
 * @see JSDoc of `hasSpansEnabled`
 * @deprecated Use `hasSpansEnabled` instead, which is a more accurately named version of this function.
 * This function will be removed in the next major version of the SDK.
 */const An=Tn;const On="production";const Cn="_frozenDsc";function Pn(t,e){const n=t;B(n,Cn,e)}function Nn(t,e){const n=e.getOptions();const{publicKey:r}=e.getDsn()||{};const s={environment:n.environment||On,release:n.release,public_key:r,trace_id:t};e.emit("createDsc",s);return s}function Rn(t,e){const n=e.getPropagationContext();return n.dsc||Nn(n.traceId,t)}
/**
 * Creates a dynamic sampling context from a span (and client and scope)
 *
 * @param span the span from which a few values like the root span name and sample rate are extracted.
 *
 * @returns a dynamic sampling context
 */function Dn(t){const e=Wt();if(!e)return{};const n=Ve(t);const r=ze(n);const s=r.data;const o=n.spanContext().traceState;const i=o?.get("sentry.sample_rate")??s[Zt]??s[Ht];function a(t){typeof i!=="number"&&typeof i!=="string"||(t.sample_rate=`${i}`);return t}const c=n[Cn];if(c)return a(c);const u=o?.get("sentry.dsc");const l=u&&Ee(u);if(l)return a(l);const p=Nn(t.spanContext().traceId,e);const f=s[Gt];const d=r.description;f!=="url"&&d&&(p.transaction=d);if(Tn()){p.sampled=String(We(n));p.sample_rand=o?.get("sentry.sample_rand")??_e(n).scope?.getPropagationContext().sampleRand.toString()}a(p);e.emit("createDsc",p,n);return p}function jn(t){const e=Dn(t);return we(e)}class SentryNonRecordingSpan{constructor(t={}){this._traceId=t.traceId||$t();this._spanId=t.spanId||Tt()}spanContext(){return{spanId:this._spanId,traceId:this._traceId,traceFlags:Pe}}end(t){}setAttribute(t,e){return this}setAttributes(t){return this}setStatus(t){return this}updateName(t){return this}isRecording(){return false}addEvent(t,e,n){return this}addLink(t){return this}addLinks(t){return this}recordException(t,e){}}function Mn(t,e,n=()=>{}){let r;try{r=t()}catch(t){e(t);n();throw t}return Ln(r,e,n)}function Ln(t,e,n){if(v(t))return t.then((t=>{n();return t}),(t=>{e(t);n();throw t}));n();return t}function Fn(e){if(!t)return;const{description:n="< unknown name >",op:r="< unknown op >",parent_span_id:s}=ze(e);const{spanId:o}=e.spanContext();const i=We(e);const a=Ve(e);const c=a===e;const u=`[Tracing] Starting ${i?"sampled":"unsampled"} ${c?"root ":""}span`;const l=[`op: ${r}`,`name: ${n}`,`ID: ${o}`];s&&l.push(`parent ID: ${s}`);if(!c){const{op:t,description:e}=ze(a);l.push(`root ID: ${a.spanContext().spanId}`);t&&l.push(`root op: ${t}`);e&&l.push(`root description: ${e}`)}j.log(`${u}\n  ${l.join("\n  ")}`)}function Un(e){if(!t)return;const{description:n="< unknown name >",op:r="< unknown op >"}=ze(e);const{spanId:s}=e.spanContext();const o=Ve(e);const i=o===e;const a=`[Tracing] Finishing "${r}" ${i?"root ":""}span "${n}" with ID ${s}`;j.log(a)}function zn(e,n,r){if(!Tn(e))return[false];let s;let o;if(typeof e.tracesSampler==="function"){o=e.tracesSampler({...n,inheritOrSampleWith:t=>typeof n.parentSampleRate==="number"?n.parentSampleRate:typeof n.parentSampled==="boolean"?Number(n.parentSampled):t});s=true}else if(n.parentSampled!==void 0)o=n.parentSampled;else if(typeof e.tracesSampleRate!=="undefined"){o=e.tracesSampleRate;s=true}const i=ye(o);if(i===void 0){t&&j.warn(`[Tracing] Discarding root span because of invalid sample rate. Sample rate must be a boolean or a number between 0 and 1. Got ${JSON.stringify(o)} of type ${JSON.stringify(typeof o)}.`);return[false]}if(!i){t&&j.log("[Tracing] Discarding transaction because "+(typeof e.tracesSampler==="function"?"tracesSampler returned 0 or false":"a negative sampling decision was inherited or tracesSampleRate is set to 0"));return[false,i,s]}const a=r<i;a||t&&j.log(`[Tracing] Discarding transaction because it's not included in the random sample (sampling rate = ${Number(o)})`);return[a,i,s]}const qn=/^(?:(\w+):)\/\/(?:(\w+)(?::(\w+)?)?@)([\w.-]+)(?::(\d+))?\/(.+)/;function Bn(t){return t==="http"||t==="https"}
/**
 * Renders the string representation of this Dsn.
 *
 * By default, this will render the public representation without the password
 * component. To get the deprecated private representation, set `withPassword`
 * to true.
 *
 * @param withPassword When set to true, the password will be included.
 */function Wn(t,e=false){const{host:n,path:r,pass:s,port:o,projectId:i,protocol:a,publicKey:c}=t;return`${a}://${c}${e&&s?`:${s}`:""}@${n}${o?`:${o}`:""}/${r?`${r}/`:r}${i}`}
/**
 * Parses a Dsn from a given string.
 *
 * @param str A Dsn as string
 * @returns Dsn as DsnComponents or undefined if @param str is not a valid DSN string
 */function Jn(t){const e=qn.exec(t);if(!e){R((()=>{console.error(`Invalid Sentry Dsn: ${t}`)}));return}const[n,r,s="",o="",i="",a=""]=e.slice(1);let c="";let u=a;const l=u.split("/");if(l.length>1){c=l.slice(0,-1).join("/");u=l.pop()}if(u){const t=u.match(/^\d+/);t&&(u=t[0])}return Gn({host:o,pass:s,path:c,projectId:u,port:i,protocol:n,publicKey:r})}function Gn(t){return{protocol:t.protocol,publicKey:t.publicKey||"",pass:t.pass||"",host:t.host,port:t.port||"",path:t.path||"",projectId:t.projectId}}function Zn(t){if(!O)return true;const{port:e,projectId:n,protocol:r}=t;const s=["protocol","publicKey","host","projectId"];const o=s.find((e=>{if(!t[e]){j.error(`Invalid Sentry Dsn: ${e} missing`);return true}return false}));if(o)return false;if(!n.match(/^\d+$/)){j.error(`Invalid Sentry Dsn: Invalid projectId ${n}`);return false}if(!Bn(r)){j.error(`Invalid Sentry Dsn: Invalid protocol ${r}`);return false}if(e&&isNaN(parseInt(e,10))){j.error(`Invalid Sentry Dsn: Invalid port ${e}`);return false}return true}
/**
 * Creates a valid Sentry Dsn object, identifying a Sentry instance and project.
 * @returns a valid DsnComponents object or `undefined` if @param from is an invalid DSN source
 */function Hn(t){const e=typeof t==="string"?Jn(t):Gn(t);if(e&&Zn(e))return e}
/**
 * Recursively normalizes the given object.
 *
 * - Creates a copy to prevent original input mutation
 * - Skips non-enumerable properties
 * - When stringifying, calls `toJSON` if implemented
 * - Removes circular references
 * - Translates non-serializable values (`undefined`/`NaN`/functions) to serializable format
 * - Translates known global objects/classes to a string representations
 * - Takes care of `Error` object serialization
 * - Optionally limits depth of final output
 * - Optionally limits number of properties/elements included in any single object/array
 *
 * @param input The object to be normalized.
 * @param depth The max depth to which to normalize the object. (Anything deeper stringified whole.)
 * @param maxProperties The max number of elements or properties to be included in any single array or
 * object in the normalized output.
 * @returns A normalized version of the object, or `"**non-serializable**"` if any errors are thrown during normalization.
 */function Yn(t,e=100,n=Infinity){try{return Vn("",t,e,n)}catch(t){return{ERROR:`**non-serializable** (${t})`}}}function Kn(t,e=3,n=102400){const r=Yn(t,e);return er(r)>n?Kn(t,e-1,n):r}
/**
 * Visits a node to perform normalization on it
 *
 * @param key The key corresponding to the given node
 * @param value The node to be visited
 * @param depth Optional number indicating the maximum recursion depth
 * @param maxProperties Optional maximum number of properties/elements included in any single object/array
 * @param memo Optional Memo class handling decycling
 */function Vn(t,e,n=Infinity,r=Infinity,s=rr()){const[o,i]=s;if(e==null||["boolean","string"].includes(typeof e)||typeof e==="number"&&Number.isFinite(e))return e;const a=Xn(t,e);if(!a.startsWith("[object "))return a;if(e.__sentry_skip_normalization__)return e;const c=typeof e.__sentry_override_normalization_depth__==="number"?e.__sentry_override_normalization_depth__:n;if(c===0)return a.replace("object ","");if(o(e))return"[Circular ~]";const u=e;if(u&&typeof u.toJSON==="function")try{const t=u.toJSON();return Vn("",t,c-1,r,s)}catch(t){}const l=Array.isArray(e)?[]:{};let p=0;const f=G(e);for(const t in f){if(!Object.prototype.hasOwnProperty.call(f,t))continue;if(p>=r){l[t]="[MaxProperties ~]";break}const e=f[t];l[t]=Vn(t,e,c-1,r,s);p++}i(e);return l}
/**
 * Stringify the given value. Handles various known special values and types.
 *
 * Not meant to be used on simple primitives which already have a string representation, as it will, for example, turn
 * the number 1231 into "[Object Number]", nor on `null`, as it will throw.
 *
 * @param value The value to stringify
 * @returns A stringified representation of the given value
 */function Xn(t,e){try{if(t==="domain"&&e&&typeof e==="object"&&e._events)return"[Domain]";if(t==="domainEmitter")return"[DomainEmitter]";if(typeof global!=="undefined"&&e===global)return"[Global]";if(typeof window!=="undefined"&&e===window)return"[Window]";if(typeof document!=="undefined"&&e===document)return"[Document]";if(E(e))return"[VueViewModel]";if(b(e))return"[SyntheticEvent]";if(typeof e==="number"&&!Number.isFinite(e))return`[${e}]`;if(typeof e==="function")return`[Function: ${pn(e)}]`;if(typeof e==="symbol")return`[${String(e)}]`;if(typeof e==="bigint")return`[BigInt: ${String(e)}]`;const n=Qn(e);return/^HTML(\w*)Element$/.test(n)?`[HTMLElement: ${n}]`:`[object ${n}]`}catch(t){return`**non-serializable** (${t})`}}function Qn(t){const e=Object.getPrototypeOf(t);return e?.constructor?e.constructor.name:"null prototype"}function tr(t){return~-encodeURI(t).split(/%..|./).length}function er(t){return tr(JSON.stringify(t))}
/**
 * Normalizes URLs in exceptions and stacktraces to a base path so Sentry can fingerprint
 * across platforms and working directory.
 *
 * @param url The URL to be normalized.
 * @param basePath The application base path.
 * @returns The normalized URL.
 */function nr(t,e){const n=e.replace(/\\/g,"/").replace(/[|\\{}()[\]^$+*?.]/g,"\\$&");let r=t;try{r=decodeURI(t)}catch(t){}return r.replace(/\\/g,"/").replace(/webpack:\/?/g,"").replace(new RegExp(`(file://)?/*${n}/*`,"ig"),"app:///")}function rr(){const t=new WeakSet;function e(e){if(t.has(e))return true;t.add(e);return false}function n(e){t.delete(e)}return[e,n]}function sr(t,e=[]){return[t,e]}function or(t,e){const[n,r]=t;return[n,[...r,e]]}function ir(t,e){const n=t[1];for(const t of n){const n=t[0].type;const r=e(t,n);if(r)return true}return false}function ar(t,e){return ir(t,((t,n)=>e.includes(n)))}function cr(t){const e=s(n);return e.encodePolyfill?e.encodePolyfill(t):(new TextEncoder).encode(t)}function ur(t){const e=s(n);return e.decodePolyfill?e.decodePolyfill(t):(new TextDecoder).decode(t)}function lr(t){const[e,n]=t;let r=JSON.stringify(e);function s(t){typeof r==="string"?r=typeof t==="string"?r+t:[cr(r),t]:r.push(typeof t==="string"?cr(t):t)}for(const t of n){const[e,n]=t;s(`\n${JSON.stringify(e)}\n`);if(typeof n==="string"||n instanceof Uint8Array)s(n);else{let t;try{t=JSON.stringify(n)}catch(e){t=JSON.stringify(Yn(n))}s(t)}}return typeof r==="string"?r:pr(r)}function pr(t){const e=t.reduce(((t,e)=>t+e.length),0);const n=new Uint8Array(e);let r=0;for(const e of t){n.set(e,r);r+=e.length}return n}function fr(t){let e=typeof t==="string"?cr(t):t;function n(t){const n=e.subarray(0,t);e=e.subarray(t+1);return n}function r(){let t=e.indexOf(10);t<0&&(t=e.length);return JSON.parse(ur(n(t)))}const s=r();const o=[];while(e.length){const t=r();const e=typeof t.length==="number"?t.length:void 0;o.push([t,e?n(e):r()])}return[s,o]}function dr(t){const e={type:"span"};return[e,t]}function hr(t){const e=typeof t.data==="string"?cr(t.data):t.data;return[{type:"attachment",length:e.length,filename:t.filename,content_type:t.contentType,attachment_type:t.attachmentType},e]}const mr={session:"session",sessions:"session",attachment:"attachment",transaction:"transaction",event:"error",client_report:"internal",user_report:"default",profile:"profile",profile_chunk:"profile",replay_event:"replay",replay_recording:"replay",check_in:"monitor",feedback:"feedback",span:"span",raw_security:"security",log:"log_item"};function gr(t){return mr[t]}function _r(t){if(!t?.sdk)return;const{name:e,version:n}=t.sdk;return{name:e,version:n}}function yr(t,e,n,r){const s=t.sdkProcessingMetadata?.dynamicSamplingContext;return{event_id:t.event_id,sent_at:(new Date).toISOString(),...e&&{sdk:e},...!!n&&r&&{dsn:Wn(r)},...s&&{trace:s}}}function vr(t,e){if(!e)return t;t.sdk=t.sdk||{};t.sdk.name=t.sdk.name||e.name;t.sdk.version=t.sdk.version||e.version;t.sdk.integrations=[...t.sdk.integrations||[],...e.integrations||[]];t.sdk.packages=[...t.sdk.packages||[],...e.packages||[]];return t}function br(t,e,n,r){const s=_r(n);const o={sent_at:(new Date).toISOString(),...s&&{sdk:s},...!!r&&e&&{dsn:Wn(e)}};const i="aggregates"in t?[{type:"sessions"},t]:[{type:"session"},t.toJSON()];return sr(o,[i])}function Sr(t,e,n,r){const s=_r(n);const o=t.type&&t.type!=="replay_event"?t.type:"event";vr(t,n?.sdk);const i=yr(t,s,r,e);delete t.sdkProcessingMetadata;const a=[{type:o},t];return sr(i,[a])}function Er(t,e){function n(t){return!!t.trace_id&&!!t.public_key}const r=Dn(t[0]);const s=e?.getDsn();const o=e?.getOptions().tunnel;const i={sent_at:(new Date).toISOString(),...n(r)&&{trace:r},...!!o&&s&&{dsn:Wn(s)}};const a=e?.getOptions().beforeSendSpan;const c=a?t=>{const e=ze(t);const n=a(e);if(!n){Qe();return e}return n}:ze;const u=[];for(const e of t){const t=c(e);t&&u.push(dr(t))}return sr(i,u)}function wr(e,n,r,s=Xe()){const o=s&&Ve(s);if(o){t&&j.log(`[Measurement] Setting measurement on root span: ${e} = ${n} ${r}`);o.addEvent(e,{[Qt]:n,[Xt]:r})}}function xr(t){if(!t||t.length===0)return;const e={};t.forEach((t=>{const n=t.attributes||{};const r=n[Xt];const s=n[Qt];typeof r==="string"&&typeof s==="number"&&(e[t.name]={value:s,unit:r})}));return e}const kr=1e3;class SentrySpan{constructor(t={}){this._traceId=t.traceId||$t();this._spanId=t.spanId||Tt();this._startTime=t.startTimestamp||mt();this._links=t.links;this._attributes={};this.setAttributes({[Kt]:"manual",[Yt]:t.op,...t.attributes});this._name=t.name;t.parentSpanId&&(this._parentSpanId=t.parentSpanId);"sampled"in t&&(this._sampled=t.sampled);t.endTimestamp&&(this._endTime=t.endTimestamp);this._events=[];this._isStandaloneSpan=t.isStandalone;this._endTime&&this._onSpanEnded()}addLink(t){this._links?this._links.push(t):this._links=[t];return this}addLinks(t){this._links?this._links.push(...t):this._links=t;return this}recordException(t,e){}spanContext(){const{_spanId:t,_traceId:e,_sampled:n}=this;return{spanId:t,traceId:e,traceFlags:n?Ne:Pe}}setAttribute(t,e){e===void 0?delete this._attributes[t]:this._attributes[t]=e;return this}setAttributes(t){Object.keys(t).forEach((e=>this.setAttribute(e,t[e])));return this}updateStartTime(t){this._startTime=Fe(t)}setStatus(t){this._status=t;return this}updateName(t){this._name=t;this.setAttribute(Gt,"custom");return this}end(t){if(!this._endTime){this._endTime=Fe(t);Un(this);this._onSpanEnded()}}getSpanJSON(){return{data:this._attributes,description:this._name,op:this._attributes[Yt],parent_span_id:this._parentSpanId,span_id:this._spanId,start_timestamp:this._startTime,status:Je(this._status),timestamp:this._endTime,trace_id:this._traceId,origin:this._attributes[Kt],profile_id:this._attributes[ee],exclusive_time:this._attributes[ne],measurements:xr(this._events),is_segment:this._isStandaloneSpan&&Ve(this)===this||void 0,segment_id:this._isStandaloneSpan?Ve(this).spanContext().spanId:void 0,links:Le(this._links)}}isRecording(){return!this._endTime&&!!this._sampled}addEvent(e,n,r){t&&j.log("[Tracing] Adding an event to span:",e);const s=Ir(n)?n:r||mt();const o=Ir(n)?{}:n||{};const i={name:e,time:Fe(s),attributes:o};this._events.push(i);return this}isStandaloneSpan(){return!!this._isStandaloneSpan}_onSpanEnded(){const e=Wt();e&&e.emit("spanEnd",this);const n=this._isStandaloneSpan||this===Ve(this);if(!n)return;if(this._isStandaloneSpan){if(this._sampled)Ar(Er([this],e));else{t&&j.log("[Tracing] Discarding standalone span because its trace was not chosen to be sampled.");e&&e.recordDroppedEvent("sample_rate","span")}return}const r=this._convertSpanToTransaction();if(r){const t=_e(this).scope||Ft();t.captureEvent(r)}}_convertSpanToTransaction(){if(!$r(ze(this)))return;if(!this._name){t&&j.warn("Transaction has no name, falling back to `<unlabeled transaction>`.");this._name="<unlabeled transaction>"}const{scope:e,isolationScope:n}=_e(this);if(this._sampled!==true)return;const r=Ke(this).filter((t=>t!==this&&!Tr(t)));const s=r.map((t=>ze(t))).filter($r);const o=this._attributes[Gt];
/* eslint-disable @typescript-eslint/no-dynamic-delete */delete this._attributes[te];s.forEach((t=>{delete t.data[te]}));const i={contexts:{trace:De(this)},spans:s.length>kr?s.sort(((t,e)=>t.start_timestamp-e.start_timestamp)).slice(0,kr):s,start_timestamp:this._startTime,timestamp:this._endTime,transaction:this._name,type:"transaction",sdkProcessingMetadata:{capturedSpanScope:e,capturedSpanIsolationScope:n,dynamicSamplingContext:Dn(this)},...o&&{transaction_info:{source:o}}};const a=xr(this._events);const c=a&&Object.keys(a).length;if(c){t&&j.log("[Measurements] Adding measurements to transaction event",JSON.stringify(a,void 0,2));i.measurements=a}return i}}function Ir(t){return t&&typeof t==="number"||t instanceof Date||Array.isArray(t)}function $r(t){return!!t.start_timestamp&&!!t.timestamp&&!!t.span_id&&!!t.trace_id}function Tr(t){return t instanceof SentrySpan&&t.isStandaloneSpan()}function Ar(t){const e=Wt();if(!e)return;const n=t[1];n&&n.length!==0?e.sendEnvelope(t):e.recordDroppedEvent("before_send","span")}const Or="__SENTRY_SUPPRESS_TRACING__";function Cr(t,e){const n=Ur();if(n.startSpan)return n.startSpan(t,e);const r=Fr(t);const{forceTransaction:s,parentSpan:o,scope:i}=t;const a=i?.clone();return qt(a,(()=>{const n=Wr(o);return n((()=>{const n=Ft();const o=Br(n);const i=t.onlyIfParent&&!o;const a=i?new SentryNonRecordingSpan:Lr({parentSpan:o,spanArguments:r,forceTransaction:s,scope:n});kt(n,a);return Mn((()=>e(a)),(()=>{const{status:t}=ze(a);!a.isRecording()||t&&t!=="ok"||a.setStatus({code:pe,message:"internal_error"})}),(()=>{a.end()}))}))}))}function Pr(t,e){const n=Ur();if(n.startSpanManual)return n.startSpanManual(t,e);const r=Fr(t);const{forceTransaction:s,parentSpan:o,scope:i}=t;const a=i?.clone();return qt(a,(()=>{const n=Wr(o);return n((()=>{const n=Ft();const o=Br(n);const i=t.onlyIfParent&&!o;const a=i?new SentryNonRecordingSpan:Lr({parentSpan:o,spanArguments:r,forceTransaction:s,scope:n});kt(n,a);return Mn((()=>e(a,(()=>a.end()))),(()=>{const{status:t}=ze(a);!a.isRecording()||t&&t!=="ok"||a.setStatus({code:pe,message:"internal_error"})}))}))}))}function Nr(t){const e=Ur();if(e.startInactiveSpan)return e.startInactiveSpan(t);const n=Fr(t);const{forceTransaction:r,parentSpan:s}=t;const o=t.scope?e=>qt(t.scope,e):s!==void 0?t=>Dr(s,t):t=>t();return o((()=>{const e=Ft();const s=Br(e);const o=t.onlyIfParent&&!s;return o?new SentryNonRecordingSpan:Lr({parentSpan:s,spanArguments:n,forceTransaction:r,scope:e})}))}const Rr=(t,e)=>{const n=r();const s=Lt(n);if(s.continueTrace)return s.continueTrace(t,e);const{sentryTrace:o,baggage:i}=t;return qt((t=>{const n=Ae(o,i);t.setPropagationContext(n);return e()}))};
/**
 * Forks the current scope and sets the provided span as active span in the context of the provided callback. Can be
 * passed `null` to start an entirely new span tree.
 *
 * @param span Spans started in the context of the provided callback will be children of this span. If `null` is passed,
 * spans started within the callback will not be attached to a parent span.
 * @param callback Execution context in which the provided span will be active. Is passed the newly forked scope.
 * @returns the value returned from the provided callback function.
 */function Dr(t,e){const n=Ur();return n.withActiveSpan?n.withActiveSpan(t,e):qt((n=>{kt(n,t||void 0);return e(n)}))}function jr(t){const e=Ur();return e.suppressTracing?e.suppressTracing(t):qt((e=>{e.setSDKProcessingMetadata({[Or]:true});return t()}))}function Mr(e){return qt((n=>{n.setPropagationContext({traceId:$t(),sampleRand:Math.random()});t&&j.info(`Starting a new trace with id ${n.getPropagationContext().traceId}`);return Dr(null,e)}))}function Lr({parentSpan:t,spanArguments:e,forceTransaction:n,scope:r}){if(!Tn()){const r=new SentryNonRecordingSpan;if(n||!t){const t={sampled:"false",sample_rate:"0",transaction:e.name,...Dn(r)};Pn(r,t)}return r}const s=Ut();let o;if(t&&!n){o=qr(t,r,e);He(t,o)}else if(t){const n=Dn(t);const{traceId:s,spanId:i}=t.spanContext();const a=We(t);o=zr({traceId:s,parentSpanId:i,...e},r,a);Pn(o,n)}else{const{traceId:t,dsc:n,parentSpanId:i,sampled:a}={...s.getPropagationContext(),...r.getPropagationContext()};o=zr({traceId:t,parentSpanId:i,...e},r,a);n&&Pn(o,n)}Fn(o);ge(o,r,s);return o}function Fr(t){const e=t.experimental||{};const n={isStandalone:e.standalone,...t};if(t.startTime){const e={...n};e.startTimestamp=Fe(t.startTime);delete e.startTime;return e}return n}function Ur(){const t=r();return Lt(t)}function zr(e,n,r){const s=Wt();const o=s?.getOptions()||{};const{name:i=""}=e;const a={spanAttributes:{...e.attributes},spanName:i,parentSampled:r};s?.emit("beforeSampling",a,{decision:false});const c=a.parentSampled??r;const u=a.spanAttributes;const l=n.getPropagationContext();const[p,f,d]=n.getScopeData().sdkProcessingMetadata[Or]?[false]:zn(o,{name:i,parentSampled:c,attributes:u,parentSampleRate:ye(l.dsc?.sample_rate)},l.sampleRand);const h=new SentrySpan({...e,attributes:{[Gt]:"custom",[Zt]:f!==void 0&&d?f:void 0,...u},sampled:p});if(!p&&s){t&&j.log("[Tracing] Discarding root span because its trace was not chosen to be sampled.");s.recordDroppedEvent("sample_rate","transaction")}s&&s.emit("spanStart",h);return h}function qr(t,e,n){const{spanId:r,traceId:s}=t.spanContext();const o=!e.getScopeData().sdkProcessingMetadata[Or]&&We(t);const i=o?new SentrySpan({...n,parentSpanId:r,traceId:s,sampled:o}):new SentryNonRecordingSpan({traceId:s});He(t,i);const a=Wt();if(a){a.emit("spanStart",i);n.endTimestamp&&a.emit("spanEnd",i)}return i}function Br(t){const e=It(t);if(!e)return;const n=Wt();const r=n?n.getOptions():{};return r.parentSpanIsAlwaysRootSpan?Ve(e):e}function Wr(t){return t!==void 0?e=>Dr(t,e):t=>t()}const Jr={idleTimeout:1e3,finalTimeout:3e4,childSpanTimeout:15e3};const Gr="heartbeatFailed";const Zr="idleTimeout";const Hr="finalTimeout";const Yr="externalFinish";function Kr(e,n={}){const r=new Map;let s=false;let o;let i=Yr;let a=!n.disableAutoFinish;const c=[];const{idleTimeout:u=Jr.idleTimeout,finalTimeout:l=Jr.finalTimeout,childSpanTimeout:p=Jr.childSpanTimeout,beforeSpanEnd:f}=n;const d=Wt();if(!d||!Tn()){const t=new SentryNonRecordingSpan;const e={sample_rate:"0",sampled:"false",...Dn(t)};Pn(t,e);return t}const h=Ft();const m=Xe();const g=Vr(e);g.end=new Proxy(g.end,{apply(t,e,n){f&&f(g);if(e instanceof SentryNonRecordingSpan)return;const[r,...s]=n;const o=r||mt();const i=Fe(o);const a=Ke(g).filter((t=>t!==g));if(!a.length){E(i);return Reflect.apply(t,e,[i,...s])}const c=a.map((t=>ze(t).timestamp)).filter((t=>!!t));const u=c.length?Math.max(...c):void 0;const p=ze(g).start_timestamp;const d=Math.min(p?p+l/1e3:Infinity,Math.max(p||-Infinity,Math.min(i,u||Infinity)));E(d);return Reflect.apply(t,e,[d,...s])}});function _(){if(o){clearTimeout(o);o=void 0}}function y(t){_();o=setTimeout((()=>{if(!s&&r.size===0&&a){i=Zr;g.end(t)}}),u)}function v(t){o=setTimeout((()=>{if(!s&&a){i=Gr;g.end(t)}}),p)}
/**
   * Start tracking a specific activity.
   * @param spanId The span id that represents the activity
   */function b(t){_();r.set(t,true);const e=mt();v(e+p/1e3)}
/**
   * Remove an activity from usage
   * @param spanId The span id that represents the activity
   */function S(t){r.has(t)&&r.delete(t);if(r.size===0){const t=mt();y(t+u/1e3)}}function E(e){s=true;r.clear();c.forEach((t=>t()));kt(h,m);const n=ze(g);const{start_timestamp:o}=n;if(!o)return;const a=n.data;a[Vt]||g.setAttribute(Vt,i);j.log(`[Tracing] Idle span "${n.op}" finished`);const p=Ke(g).filter((t=>t!==g));let f=0;p.forEach((n=>{if(n.isRecording()){n.setStatus({code:pe,message:"cancelled"});n.end(e);t&&j.log("[Tracing] Cancelling span since span ended early",JSON.stringify(n,void 0,2))}const r=ze(n);const{timestamp:s=0,start_timestamp:o=0}=r;const i=o<=e;const a=(l+u)/1e3;const c=s-o<=a;if(t){const t=JSON.stringify(n,void 0,2);i?c||j.log("[Tracing] Discarding span since it finished after idle span final timeout",t):j.log("[Tracing] Discarding span since it happened after idle span was finished",t)}if(!c||!i){Ye(g,n);f++}}));f>0&&g.setAttribute("sentry.idle_span_discarded_spans",f)}c.push(d.on("spanStart",(t=>{if(s||t===g||!!ze(t).timestamp)return;const e=Ke(g);e.includes(t)&&b(t.spanContext().spanId)})));c.push(d.on("spanEnd",(t=>{s||S(t.spanContext().spanId)})));c.push(d.on("idleSpanEnableAutoFinish",(t=>{if(t===g){a=true;y();r.size&&v()}})));n.disableAutoFinish||y();setTimeout((()=>{if(!s){g.setStatus({code:pe,message:"deadline_exceeded"});i=Hr;g.end()}}),l);return g}function Vr(e){const n=Nr(e);kt(Ft(),n);t&&j.log("[Tracing] Started span is an idle span");return n}
/* eslint-disable @typescript-eslint/no-explicit-any */var Xr;(function(t){const e=0;t[t.PENDING=e]="PENDING";const n=1;t[t.RESOLVED=n]="RESOLVED";const r=2;t[t.REJECTED=r]="REJECTED"})(Xr||(Xr={}));
/**
 * Creates a resolved sync promise.
 *
 * @param value the value to resolve the promise with
 * @returns the resolved sync promise
 */function Qr(t){return new SyncPromise((e=>{e(t)}))}
/**
 * Creates a rejected sync promise.
 *
 * @param value the value to reject the promise with
 * @returns the rejected sync promise
 */function ts(t){return new SyncPromise(((e,n)=>{n(t)}))}class SyncPromise{constructor(t){this._state=Xr.PENDING;this._handlers=[];this._runExecutor(t)}then(t,e){return new SyncPromise(((n,r)=>{this._handlers.push([false,e=>{if(t)try{n(t(e))}catch(t){r(t)}else n(e)},t=>{if(e)try{n(e(t))}catch(t){r(t)}else r(t)}]);this._executeHandlers()}))}catch(t){return this.then((t=>t),t)}finally(t){return new SyncPromise(((e,n)=>{let r;let s;return this.then((e=>{s=false;r=e;t&&t()}),(e=>{s=true;r=e;t&&t()})).then((()=>{s?n(r):e(r)}))}))}_executeHandlers(){if(this._state===Xr.PENDING)return;const t=this._handlers.slice();this._handlers=[];t.forEach((t=>{if(!t[0]){this._state===Xr.RESOLVED&&t[1](this._value);this._state===Xr.REJECTED&&t[2](this._value);t[0]=true}}))}_runExecutor(t){const e=(t,e)=>{if(this._state===Xr.PENDING)if(v(e))void e.then(n,r);else{this._state=t;this._value=e;this._executeHandlers()}};const n=t=>{e(Xr.RESOLVED,t)};const r=t=>{e(Xr.REJECTED,t)};try{t(n,r)}catch(t){r(t)}}}function es(e,n,r,s=0){return new SyncPromise(((o,i)=>{const a=e[s];if(n===null||typeof a!=="function")o(n);else{const c=a({...n},r);t&&a.id&&c===null&&j.log(`Event processor "${a.id}" dropped event`);v(c)?void c.then((t=>es(e,t,r,s+1).then(o))).then(null,i):void es(e,c,r,s+1).then(o).then(null,i)}}))}let ns;let rs;let ss;function os(t){const e=n._sentryDebugIds;if(!e)return{};const r=Object.keys(e);if(ss&&r.length===rs)return ss;rs=r.length;ss=r.reduce(((n,r)=>{ns||(ns={});const s=ns[r];if(s)n[s[0]]=s[1];else{const s=t(r);for(let t=s.length-1;t>=0;t--){const o=s[t];const i=o?.filename;const a=e[r];if(i&&a){n[i]=a;ns[r]=[i,a];break}}}return n}),{});return ss}function is(t,e){const n=os(t);if(!n)return[];const r=[];for(const t of e)t&&n[t]&&r.push({type:"sourcemap",code_file:t,debug_id:n[t]});return r}function as(t,e){const{fingerprint:n,span:r,breadcrumbs:s,sdkProcessingMetadata:o}=e;ls(t,e);r&&ds(t,r);hs(t,n);ps(t,s);fs(t,o)}function cs(t,e){const{extra:n,tags:r,user:s,contexts:o,level:i,sdkProcessingMetadata:a,breadcrumbs:c,fingerprint:u,eventProcessors:l,attachments:p,propagationContext:f,transactionName:d,span:h}=e;us(t,"extra",n);us(t,"tags",r);us(t,"user",s);us(t,"contexts",o);t.sdkProcessingMetadata=wt(t.sdkProcessingMetadata,a,2);i&&(t.level=i);d&&(t.transactionName=d);h&&(t.span=h);c.length&&(t.breadcrumbs=[...t.breadcrumbs,...c]);u.length&&(t.fingerprint=[...t.fingerprint,...u]);l.length&&(t.eventProcessors=[...t.eventProcessors,...l]);p.length&&(t.attachments=[...t.attachments,...p]);t.propagationContext={...t.propagationContext,...f}}function us(t,e,n){t[e]=wt(t[e],n,1)}function ls(t,e){const{extra:n,tags:r,user:s,contexts:o,level:i,transactionName:a}=e;Object.keys(n).length&&(t.extra={...n,...t.extra});Object.keys(r).length&&(t.tags={...r,...t.tags});Object.keys(s).length&&(t.user={...s,...t.user});Object.keys(o).length&&(t.contexts={...o,...t.contexts});i&&(t.level=i);a&&t.type!=="transaction"&&(t.transaction=a)}function ps(t,e){const n=[...t.breadcrumbs||[],...e];t.breadcrumbs=n.length?n:void 0}function fs(t,e){t.sdkProcessingMetadata={...t.sdkProcessingMetadata,...e}}function ds(t,e){t.contexts={trace:je(e),...t.contexts};t.sdkProcessingMetadata={dynamicSamplingContext:Dn(e),...t.sdkProcessingMetadata};const n=Ve(e);const r=ze(n).description;r&&!t.transaction&&t.type==="transaction"&&(t.transaction=r)}function hs(t,e){t.fingerprint=t.fingerprint?Array.isArray(t.fingerprint)?t.fingerprint:[t.fingerprint]:[];e&&(t.fingerprint=t.fingerprint.concat(e));t.fingerprint.length||delete t.fingerprint}
/**
 * Adds common information to events.
 *
 * The information includes release and environment from `options`,
 * breadcrumbs and context (extra, tags and user) from the scope.
 *
 * Information that is already present in the event is never overwritten. For
 * nested objects, such as the context, keys are merged.
 *
 * @param event The original event.
 * @param hint May contain additional information about the original exception.
 * @param scope A scope containing event metadata.
 * @returns A new event with more information.
 * @hidden
 */function ms(t,e,n,r,s,o){const{normalizeDepth:i=3,normalizeMaxBreadth:a=1e3}=t;const c={...e,event_id:e.event_id||n.event_id||et(),timestamp:e.timestamp||dt()};const u=n.integrations||t.integrations.map((t=>t.name));gs(c,t);vs(c,u);s&&s.emit("applyFrameMetadata",e);e.type===void 0&&_s(c,t.stackParser);const l=Ss(r,n.captureContext);n.mechanism&&ot(c,n.mechanism);const p=s?s.getEventProcessors():[];const f=zt().getScopeData();if(o){const t=o.getScopeData();cs(f,t)}if(l){const t=l.getScopeData();cs(f,t)}const d=[...n.attachments||[],...f.attachments];d.length&&(n.attachments=d);as(c,f);const h=[...p,...f.eventProcessors];const m=es(h,c,n);return m.then((t=>{t&&ys(t);return typeof i==="number"&&i>0?bs(t,i,a):t}))}
/**
 * Enhances event using the client configuration.
 * It takes care of all "static" values like environment, release and `dist`,
 * as well as truncating overly long values.
 *
 * Only exported for tests.
 *
 * @param event event instance to be enhanced
 */function gs(t,e){const{environment:n,release:r,dist:s,maxValueLength:o=250}=e;t.environment=t.environment||n||On;!t.release&&r&&(t.release=r);!t.dist&&s&&(t.dist=s);const i=t.request;i?.url&&(i.url=M(i.url,o))}function _s(t,e){const n=os(e);t.exception?.values?.forEach((t=>{t.stacktrace?.frames?.forEach((t=>{t.filename&&(t.debug_id=n[t.filename])}))}))}function ys(t){const e={};t.exception?.values?.forEach((t=>{t.stacktrace?.frames?.forEach((t=>{if(t.debug_id){t.abs_path?e[t.abs_path]=t.debug_id:t.filename&&(e[t.filename]=t.debug_id);delete t.debug_id}}))}));if(Object.keys(e).length===0)return;t.debug_meta=t.debug_meta||{};t.debug_meta.images=t.debug_meta.images||[];const n=t.debug_meta.images;Object.entries(e).forEach((([t,e])=>{n.push({type:"sourcemap",code_file:t,debug_id:e})}))}
/**
 * This function adds all used integrations to the SDK info in the event.
 * @param event The event that will be filled with all integrations.
 */function vs(t,e){if(e.length>0){t.sdk=t.sdk||{};t.sdk.integrations=[...t.sdk.integrations||[],...e]}}
/**
 * Applies `normalize` function on necessary `Event` attributes to make them safe for serialization.
 * Normalized keys:
 * - `breadcrumbs.data`
 * - `user`
 * - `contexts`
 * - `extra`
 * @param event Event
 * @returns Normalized event
 */function bs(t,e,n){if(!t)return null;const r={...t,...t.breadcrumbs&&{breadcrumbs:t.breadcrumbs.map((t=>({...t,...t.data&&{data:Yn(t.data,e,n)}})))},...t.user&&{user:Yn(t.user,e,n)},...t.contexts&&{contexts:Yn(t.contexts,e,n)},...t.extra&&{extra:Yn(t.extra,e,n)}};if(t.contexts?.trace&&r.contexts){r.contexts.trace=t.contexts.trace;t.contexts.trace.data&&(r.contexts.trace.data=Yn(t.contexts.trace.data,e,n))}t.spans&&(r.spans=t.spans.map((t=>({...t,...t.data&&{data:Yn(t.data,e,n)}}))));t.contexts?.flags&&r.contexts&&(r.contexts.flags=Yn(t.contexts.flags,3,n));return r}function Ss(t,e){if(!e)return t;const n=t?t.clone():new Scope;n.update(e);return n}function Es(t){if(t)return ws(t)||ks(t)?{captureContext:t}:t}function ws(t){return t instanceof Scope||typeof t==="function"}const xs=["user","level","extra","contexts","tags","fingerprint","propagationContext"];function ks(t){return Object.keys(t).some((t=>xs.includes(t)))}
/**
 * Captures an exception event and sends it to Sentry.
 *
 * @param exception The exception to capture.
 * @param hint Optional additional data to attach to the Sentry event.
 * @returns the id of the captured Sentry event.
 */function Is(t,e){return Ft().captureException(t,Es(e))}
/**
 * Captures a message event and sends it to Sentry.
 *
 * @param message The message to send to Sentry.
 * @param captureContext Define the level of the message or pass in additional data to attach to the message.
 * @returns the id of the captured message.
 */function $s(t,e){const n=typeof e==="string"?e:void 0;const r=typeof e!=="string"?{captureContext:e}:void 0;return Ft().captureMessage(t,n,r)}
/**
 * Captures a manually created event and sends it to Sentry.
 *
 * @param event The event to send to Sentry.
 * @param hint Optional additional data to attach to the Sentry event.
 * @returns the id of the captured event.
 */function Ts(t,e){return Ft().captureEvent(t,e)}
/**
 * Sets context data with the given name.
 * @param name of the context
 * @param context Any kind of data. This data will be normalized.
 */function As(t,e){Ut().setContext(t,e)}
/**
 * Set an object that will be merged sent as extra data with the event.
 * @param extras Extras object to merge into current context.
 */function Os(t){Ut().setExtras(t)}
/**
 * Set key:value that will be sent as extra data with the event.
 * @param key String of extra
 * @param extra Any kind of data. This data will be normalized.
 */function Cs(t,e){Ut().setExtra(t,e)}
/**
 * Set an object that will be merged sent as tags data with the event.
 * @param tags Tags context object to merge into current context.
 */function Ps(t){Ut().setTags(t)}
/**
 * Set key:value that will be sent as tags data with the event.
 *
 * Can also be used to unset a tag, by passing `undefined`.
 *
 * @param key String key of tag
 * @param value Value of tag
 */function Ns(t,e){Ut().setTag(t,e)}
/**
 * Updates user context information for future events.
 *
 * @param user User context object to be set in the current context. Pass `null` to unset the user.
 */function Rs(t){Ut().setUser(t)}
/**
 * The last error event id of the isolation scope.
 *
 * Warning: This function really returns the last recorded error event id on the current
 * isolation scope. If you call this function after handling a certain error and another error
 * is captured in between, the last one is returned instead of the one you might expect.
 * Also, ids of events that were never sent to Sentry (for example because
 * they were dropped in `beforeSend`) could be returned.
 *
 * @returns The last event id of the isolation scope.
 */function Ds(){return Ut().lastEventId()}
/**
 * Create a cron monitor check in and send it to Sentry.
 *
 * @param checkIn An object that describes a check in.
 * @param upsertMonitorConfig An optional object that describes a monitor config. Use this if you want
 * to create a monitor automatically when sending a check in.
 */function js(e,n){const r=Ft();const s=Wt();if(s){if(s.captureCheckIn)return s.captureCheckIn(e,n,r);t&&j.warn("Cannot capture check-in. Client does not support sending check-ins.")}else t&&j.warn("Cannot capture check-in. No client defined.");return et()}
/**
 * Wraps a callback with a cron monitor check in. The check in will be sent to Sentry when the callback finishes.
 *
 * @param monitorSlug The distinct slug of the monitor.
 * @param upsertMonitorConfig An optional object that describes a monitor config. Use this if you want
 * to create a monitor automatically when sending a check in.
 */function Ms(t,e,n){const r=js({monitorSlug:t,status:"in_progress"},n);const s=mt();function o(e){js({monitorSlug:t,status:e,checkInId:r,duration:mt()-s})}return Bt((()=>{let t;try{t=e()}catch(t){o("error");throw t}v(t)?Promise.resolve(t).then((()=>{o("ok")}),(t=>{o("error");throw t})):o("ok");return t}))}
/**
 * Call `flush()` on the current client, if there is one. See {@link Client.flush}.
 *
 * @param timeout Maximum time in ms the client should wait to flush its event queue. Omitting this parameter will cause
 * the client to wait until all events are sent before resolving the promise.
 * @returns A promise which resolves to `true` if the queue successfully drains before the timeout, or `false` if it
 * doesn't (or if there's no client defined).
 */async function Ls(e){const n=Wt();if(n)return n.flush(e);t&&j.warn("Cannot flush events. No client defined.");return Promise.resolve(false)}
/**
 * Call `close()` on the current client, if there is one. See {@link Client.close}.
 *
 * @param timeout Maximum time in ms the client should wait to flush its event queue before shutting down. Omitting this
 * parameter will cause the client to wait until all events are sent before disabling itself.
 * @returns A promise which resolves to `true` if the queue successfully drains before the timeout, or `false` if it
 * doesn't (or if there's no client defined).
 */async function Fs(e){const n=Wt();if(n)return n.close(e);t&&j.warn("Cannot flush events and disable SDK. No client defined.");return Promise.resolve(false)}function Us(){return!!Wt()}function zs(){const t=Wt();return t?.getOptions().enabled!==false&&!!t?.getTransport()}function qs(t){Ut().addEventProcessor(t)}
/**
 * Start a session on the current isolation scope.
 *
 * @param context (optional) additional properties to be applied to the returned session object
 *
 * @returns the new active session
 */function Bs(t){const e=Ut();const r=Ft();const{userAgent:s}=n.navigator||{};const o=vt({user:r.getUser()||e.getUser(),...s&&{userAgent:s},...t});const i=e.getSession();i?.status==="ok"&&bt(i,{status:"exited"});Ws();e.setSession(o);return o}function Ws(){const t=Ut();const e=Ft();const n=e.getSession()||t.getSession();n&&St(n);Js();t.setSession()}function Js(){const t=Ut();const e=Wt();const n=t.getSession();n&&e&&e.captureSession(n)}
/**
 * Sends the current session on the scope to Sentry
 *
 * @param end If set the session will be marked as exited and removed from the scope.
 *            Defaults to `false`.
 */function Gs(t=false){t?Ws():Js()}const Zs="7";function Hs(t){const e=t.protocol?`${t.protocol}:`:"";const n=t.port?`:${t.port}`:"";return`${e}//${t.host}${n}${t.path?`/${t.path}`:""}/api/`}function Ys(t){return`${Hs(t)}${t.projectId}/envelope/`}function Ks(t,e){const n={sentry_version:Zs};t.publicKey&&(n.sentry_key=t.publicKey);e&&(n.sentry_client=`${e.name}/${e.version}`);return new URLSearchParams(n).toString()}function Vs(t,e,n){return e||`${Ys(t)}?${Ks(t,n)}`}function Xs(t,e){const n=Hn(t);if(!n)return"";const r=`${Hs(n)}embed/error-page/`;let s=`dsn=${Wn(n)}`;for(const t in e)if(t!=="dsn"&&t!=="onClose")if(t==="user"){const t=e.user;if(!t)continue;t.name&&(s+=`&name=${encodeURIComponent(t.name)}`);t.email&&(s+=`&email=${encodeURIComponent(t.email)}`)}else s+=`&${encodeURIComponent(t)}=${encodeURIComponent(e[t])}`;return`${r}?${s}`}const Qs=[];function to(t){const e={};t.forEach((t=>{const{name:n}=t;const r=e[n];r&&!r.isDefaultInstance&&t.isDefaultInstance||(e[n]=t)}));return Object.values(e)}function eo(t){const e=t.defaultIntegrations||[];const n=t.integrations;e.forEach((t=>{t.isDefaultInstance=true}));let r;if(Array.isArray(n))r=[...e,...n];else if(typeof n==="function"){const t=n(e);r=Array.isArray(t)?t:[t]}else r=e;return to(r)}
/**
 * Given a list of integration instances this installs them all. When `withDefaults` is set to `true` then all default
 * integrations are added unless they were already provided before.
 * @param integrations array of integration instances
 * @param withDefault should enable default integrations
 */function no(t,e){const n={};e.forEach((e=>{e&&so(t,e,n)}));return n}function ro(t,e){for(const n of e)n?.afterAllSetup&&n.afterAllSetup(t)}function so(e,n,r){if(r[n.name])t&&j.log(`Integration skipped because it was already installed: ${n.name}`);else{r[n.name]=n;if(Qs.indexOf(n.name)===-1&&typeof n.setupOnce==="function"){n.setupOnce();Qs.push(n.name)}n.setup&&typeof n.setup==="function"&&n.setup(e);if(typeof n.preprocessEvent==="function"){const t=n.preprocessEvent.bind(n);e.on("preprocessEvent",((n,r)=>t(n,r,e)))}if(typeof n.processEvent==="function"){const t=n.processEvent.bind(n);const r=Object.assign(((n,r)=>t(n,r,e)),{id:n.name});e.addEventProcessor(r)}t&&j.log(`Integration installed: ${n.name}`)}}function oo(e){const n=Wt();n?n.addIntegration(e):t&&j.warn(`Cannot add integration "${e.name}" because no SDK Client is available.`)}function io(t){return t}function ao(t){const e=[];t.message&&e.push(t.message);try{const n=t.exception.values[t.exception.values.length-1];if(n?.value){e.push(n.value);n.type&&e.push(`${n.type}: ${n.value}`)}}catch(t){}return e}function co(t){const{trace_id:e,parent_span_id:n,span_id:r,status:s,origin:o,data:i,op:a}=t.contexts?.trace??{};return{data:i??{},description:t.transaction,op:a,parent_span_id:n,span_id:r??"",start_timestamp:t.start_timestamp??0,status:s,timestamp:t.timestamp,trace_id:e??"",origin:o,profile_id:i?.[ee],exclusive_time:i?.[ne],measurements:t.measurements,is_segment:true}}function uo(t){return{type:"transaction",timestamp:t.timestamp,start_timestamp:t.start_timestamp,transaction:t.description,contexts:{trace:{trace_id:t.trace_id,span_id:t.span_id,parent_span_id:t.parent_span_id,op:t.op,status:t.status,origin:t.origin,data:{...t.data,...t.profile_id&&{[ee]:t.profile_id},...t.exclusive_time&&{[ne]:t.exclusive_time}}}},measurements:t.measurements}}
/**
 * Creates client report envelope
 * @param discarded_events An array of discard events
 * @param dsn A DSN that can be set on the header. Optional.
 */function lo(t,e,n){const r=[{type:"client_report"},{timestamp:n||dt(),discarded_events:t}];return sr(e?{dsn:e}:{},[r])}const po="Not capturing exception because it's already been captured.";const fo="Discarded session because of missing or non-string release";const ho=Symbol.for("SentryInternalError");const mo=Symbol.for("SentryDoNotSendEventError");function go(t){return{message:t,[ho]:true}}function _o(t){return{message:t,[mo]:true}}function yo(t){return!!t&&typeof t==="object"&&ho in t}function vo(t){return!!t&&typeof t==="object"&&mo in t}class Client{
/**
   * Initializes this client instance.
   *
   * @param options Options for the client.
   */
constructor(e){this._options=e;this._integrations={};this._numProcessing=0;this._outcomes={};this._hooks={};this._eventProcessors=[];e.dsn?this._dsn=Hn(e.dsn):t&&j.warn("No DSN provided, client will not send events.");if(this._dsn){const t=Vs(this._dsn,e.tunnel,e._metadata?e._metadata.sdk:void 0);this._transport=e.transport({tunnel:this._options.tunnel,recordDroppedEvent:this.recordDroppedEvent.bind(this),...e.transportOptions,url:t})}}captureException(e,n,r){const s=et();if(lt(e)){t&&j.log(po);return s}const o={event_id:s,...n};this._process(this.eventFromException(e,o).then((t=>this._captureEvent(t,o,r))));return o.event_id}captureMessage(t,e,n,r){const s={event_id:et(),...n};const o=d(t)?t:String(t);const i=h(t)?this.eventFromMessage(o,e,s):this.eventFromException(t,s);this._process(i.then((t=>this._captureEvent(t,s,r))));return s.event_id}captureEvent(e,n,r){const s=et();if(n?.originalException&&lt(n.originalException)){t&&j.log(po);return s}const o={event_id:s,...n};const i=e.sdkProcessingMetadata||{};const a=i.capturedSpanScope;const c=i.capturedSpanIsolationScope;this._process(this._captureEvent(e,o,a||r,c));return o.event_id}captureSession(t){this.sendSession(t);bt(t,{init:false})}
/**
   * Create a cron monitor check in and send it to Sentry. This method is not available on all clients.
   *
   * @param checkIn An object that describes a check in.
   * @param upsertMonitorConfig An optional object that describes a monitor config. Use this if you want
   * to create a monitor automatically when sending a check in.
   * @param scope An optional scope containing event metadata.
   * @returns A string representing the id of the check in.
   */getDsn(){return this._dsn}getOptions(){return this._options}getSdkMetadata(){return this._options._metadata}getTransport(){return this._transport}
/**
   * Wait for all events to be sent or the timeout to expire, whichever comes first.
   *
   * @param timeout Maximum time in ms the client should wait for events to be flushed. Omitting this parameter will
   *   cause the client to wait until all events are sent before resolving the promise.
   * @returns A promise that will resolve with `true` if all events are sent before the timeout, or `false` if there are
   * still events in the queue when the timeout is reached.
   */flush(t){const e=this._transport;if(e){this.emit("flush");return this._isClientDoneProcessing(t).then((n=>e.flush(t).then((t=>n&&t))))}return Qr(true)}
/**
   * Flush the event queue and set the client to `enabled = false`. See {@link Client.flush}.
   *
   * @param {number} timeout Maximum time in ms the client should wait before shutting down. Omitting this parameter will cause
   *   the client to wait until all events are sent before disabling itself.
   * @returns {Promise<boolean>} A promise which resolves to `true` if the flush completes successfully before the timeout, or `false` if
   * it doesn't.
   */close(t){return this.flush(t).then((t=>{this.getOptions().enabled=false;this.emit("close");return t}))}getEventProcessors(){return this._eventProcessors}addEventProcessor(t){this._eventProcessors.push(t)}init(){(this._isEnabled()||this._options.integrations.some((({name:t})=>t.startsWith("Spotlight"))))&&this._setupIntegrations()}
/**
   * Gets an installed integration by its name.
   *
   * @returns {Integration|undefined} The installed integration or `undefined` if no integration with that `name` was installed.
   */getIntegrationByName(t){return this._integrations[t]}addIntegration(t){const e=this._integrations[t.name];so(this,t,this._integrations);e||ro(this,[t])}sendEvent(t,e={}){this.emit("beforeSendEvent",t,e);let n=Sr(t,this._dsn,this._options._metadata,this._options.tunnel);for(const t of e.attachments||[])n=or(n,hr(t));const r=this.sendEnvelope(n);r&&r.then((e=>this.emit("afterSendEvent",t,e)),null)}sendSession(e){const{release:n,environment:r=On}=this._options;if("aggregates"in e){const s=e.attrs||{};if(!s.release&&!n){t&&j.warn(fo);return}s.release=s.release||n;s.environment=s.environment||r;e.attrs=s}else{if(!e.release&&!n){t&&j.warn(fo);return}e.release=e.release||n;e.environment=e.environment||r}this.emit("beforeSendSession",e);const s=br(e,this._dsn,this._options._metadata,this._options.tunnel);this.sendEnvelope(s)}recordDroppedEvent(e,n,r=1){if(this._options.sendClientReports){const s=`${e}:${n}`;t&&j.log(`Recording outcome: "${s}"${r>1?` (${r} times)`:""}`);this._outcomes[s]=(this._outcomes[s]||0)+r}}
/* eslint-disable @typescript-eslint/unified-signatures */
/**
   * Register a callback for whenever a span is started.
   * Receives the span as argument.
   * @returns {() => void} A function that, when executed, removes the registered callback.
   */on(t,e){const n=this._hooks[t]=this._hooks[t]||[];n.push(e);return()=>{const t=n.indexOf(e);t>-1&&n.splice(t,1)}}emit(t,...e){const n=this._hooks[t];n&&n.forEach((t=>t(...e)))}sendEnvelope(e){this.emit("beforeEnvelope",e);if(this._isEnabled()&&this._transport)return this._transport.send(e).then(null,(e=>{t&&j.error("Error while sending envelope:",e);return e}));t&&j.error("Transport disabled");return Qr({})}
/* eslint-enable @typescript-eslint/unified-signatures */_setupIntegrations(){const{integrations:t}=this._options;this._integrations=no(this,t);ro(this,t)}_updateSessionFromEvent(t,e){let n=e.level==="fatal";let r=false;const s=e.exception?.values;if(s){r=true;for(const t of s){const e=t.mechanism;if(e?.handled===false){n=true;break}}}const o=t.status==="ok";const i=o&&t.errors===0||o&&n;if(i){bt(t,{...n&&{status:"crashed"},errors:t.errors||Number(r||n)});this.captureSession(t)}}
/**
   * Determine if the client is finished processing. Returns a promise because it will wait `timeout` ms before saying
   * "no" (resolving to `false`) in order to give the client a chance to potentially finish first.
   *
   * @param timeout The time, in ms, after which to resolve to `false` if the client is still busy. Passing `0` (or not
   * passing anything) will make the promise wait as long as it takes for processing to finish before resolving to
   * `true`.
   * @returns A promise which will resolve to `true` if processing is already done or finishes before the timeout, and
   * `false` otherwise
   */_isClientDoneProcessing(t){return new SyncPromise((e=>{let n=0;const r=1;const s=setInterval((()=>{if(this._numProcessing==0){clearInterval(s);e(true)}else{n+=r;if(t&&n>=t){clearInterval(s);e(false)}}}),r)}))}_isEnabled(){return this.getOptions().enabled!==false&&this._transport!==void 0}
/**
   * Adds common information to events.
   *
   * The information includes release and environment from `options`,
   * breadcrumbs and context (extra, tags and user) from the scope.
   *
   * Information that is already present in the event is never overwritten. For
   * nested objects, such as the context, keys are merged.
   *
   * @param event The original event.
   * @param hint May contain additional information about the original exception.
   * @param currentScope A scope containing event metadata.
   * @returns A new event with more information.
   */_prepareEvent(t,e,n,r){const s=this.getOptions();const o=Object.keys(this._integrations);!e.integrations&&o?.length&&(e.integrations=o);this.emit("preprocessEvent",t,e);t.type||r.setLastEventId(t.event_id||e.event_id);return ms(s,t,e,n,this,r).then((t=>{if(t===null)return t;this.emit("postprocessEvent",t,e);t.contexts={trace:Jt(n),...t.contexts};const r=Rn(this,n);t.sdkProcessingMetadata={dynamicSamplingContext:r,...t.sdkProcessingMetadata};return t}))}
/**
   * Processes the event and logs an error in case of rejection
   * @param event
   * @param hint
   * @param scope
   */_captureEvent(e,n={},r=Ft(),s=Ut()){t&&wo(e)&&j.log(`Captured error event \`${ao(e)[0]||"<unknown>"}\``);return this._processEvent(e,n,r,s).then((t=>t.event_id),(e=>{t&&(vo(e)?j.log(e.message):yo(e)?j.warn(e.message):j.warn(e))}))}
/**
   * Processes an event (either error or message) and sends it to Sentry.
   *
   * This also adds breadcrumbs and context information to the event. However,
   * platform specific meta data (such as the User's IP address) must be added
   * by the SDK implementor.
   *
   *
   * @param event The event to send to Sentry.
   * @param hint May contain additional information about the original exception.
   * @param currentScope A scope containing event metadata.
   * @returns A SyncPromise that resolves with the event or rejects in case event was/will not be send.
   */_processEvent(t,e,n,r){const s=this.getOptions();const{sampleRate:o}=s;const i=xo(t);const a=wo(t);const c=t.type||"error";const u=`before send for type \`${c}\``;const l=typeof o==="undefined"?void 0:ye(o);if(a&&typeof l==="number"&&Math.random()>l){this.recordDroppedEvent("sample_rate","error");return ts(_o(`Discarding event because it's not included in the random sample (sampling rate = ${o})`))}const p=c==="replay_event"?"replay":c;return this._prepareEvent(t,e,n,r).then((t=>{if(t===null){this.recordDroppedEvent("event_processor",p);throw _o("An event processor returned `null`, will not send event.")}const n=e.data&&e.data.__sentry__===true;if(n)return t;const r=Eo(this,s,t,e);return So(r,u)})).then((s=>{if(s===null){this.recordDroppedEvent("before_send",p);if(i){const e=t.spans||[];const n=1+e.length;this.recordDroppedEvent("before_send","span",n)}throw _o(`${u} returned \`null\`, will not send event.`)}const o=n.getSession()||r.getSession();a&&o&&this._updateSessionFromEvent(o,s);if(i){const t=s.sdkProcessingMetadata?.spanCountBeforeProcessing||0;const e=s.spans?s.spans.length:0;const n=t-e;n>0&&this.recordDroppedEvent("before_send","span",n)}const c=s.transaction_info;if(i&&c&&s.transaction!==t.transaction){const t="custom";s.transaction_info={...c,source:t}}this.sendEvent(s,e);return s})).then(null,(t=>{if(vo(t)||yo(t))throw t;this.captureException(t,{data:{__sentry__:true},originalException:t});throw go(`Event processing pipeline threw an error, original event will not be sent. Details have been sent as a new event.\nReason: ${t}`)}))}_process(t){this._numProcessing++;void t.then((t=>{this._numProcessing--;return t}),(t=>{this._numProcessing--;return t}))}_clearOutcomes(){const t=this._outcomes;this._outcomes={};return Object.entries(t).map((([t,e])=>{const[n,r]=t.split(":");return{reason:n,category:r,quantity:e}}))}_flushOutcomes(){t&&j.log("Flushing outcomes...");const e=this._clearOutcomes();if(e.length===0){t&&j.log("No outcomes to send");return}if(!this._dsn){t&&j.log("No dsn provided, will not send outcomes");return}t&&j.log("Sending outcomes:",e);const n=lo(e,this._options.tunnel&&Wn(this._dsn));this.sendEnvelope(n)}}
/**
 * @deprecated Use `Client` instead. This alias may be removed in a future major version.
 */
/**
 * @deprecated Use `Client` instead. This alias may be removed in a future major version.
 */const bo=Client;function So(t,e){const n=`${e} must return \`null\` or a valid event.`;if(v(t))return t.then((t=>{if(!m(t)&&t!==null)throw go(n);return t}),(t=>{throw go(`${e} rejected with ${t}`)}));if(!m(t)&&t!==null)throw go(n);return t}function Eo(t,e,n,r){const{beforeSend:s,beforeSendTransaction:o,beforeSendSpan:i}=e;let a=n;if(wo(a)&&s)return s(a,r);if(xo(a)){if(i){const t=i(co(a));t?a=wt(n,uo(t)):Qe();if(a.spans){const t=[];for(const e of a.spans){const n=i(e);if(n)t.push(n);else{Qe();t.push(e)}}a.spans=t}}if(o){if(a.spans){const t=a.spans.length;a.sdkProcessingMetadata={...n.sdkProcessingMetadata,spanCountBeforeProcessing:t}}return o(a,r)}}return a}function wo(t){return t.type===void 0}function xo(t){return t.type==="transaction"}function ko(t,e){if(!e)return[void 0,void 0];const n=It(e);const r=n?je(n):Jt(e);const s=n?Dn(n):Rn(t,e);return[s,r]}function Io(t,e,n,r,s){const o={sent_at:(new Date).toISOString()};n?.sdk&&(o.sdk={name:n.sdk.name,version:n.sdk.version});!r||!s||(o.dsn=Wn(s));e&&(o.trace=e);const i=$o(t);return sr(o,[i])}function $o(t){const e={type:"check_in"};return[e,t]}const To={trace:1,debug:5,info:9,warn:13,error:17,fatal:21};
/**
 * Creates a log container envelope item for a list of logs.
 *
 * @param items - The logs to include in the envelope.
 * @returns The created log container envelope item.
 */function Ao(t){return[{type:"log",item_count:t.length,content_type:"application/vnd.sentry.items.log+json"},{items:t}]}
/**
 * Creates an envelope for a list of logs.
 *
 * Logs from multiple traces can be included in the same envelope.
 *
 * @param logs - The logs to include in the envelope.
 * @param metadata - The metadata to include in the envelope.
 * @param tunnel - The tunnel to include in the envelope.
 * @param dsn - The DSN to include in the envelope.
 * @returns The created envelope.
 */function Oo(t,e,n,r){const s={};e?.sdk&&(s.sdk={name:e.sdk.name,version:e.sdk.version});!n||!r||(s.dsn=Wn(r));return sr(s,[Ao(t)])}const Co=100;n._sentryClientToLogBufferMap=new WeakMap;
/**
 * Converts a log attribute to a serialized log attribute.
 *
 * @param key - The key of the log attribute.
 * @param value - The value of the log attribute.
 * @returns The serialized log attribute.
 */function Po(t){switch(typeof t){case"number":return Number.isInteger(t)?{value:t,type:"integer"}:{value:t,type:"double"};case"boolean":return{value:t,type:"boolean"};case"string":return{value:t,type:"string"};default:{let e="";try{e=JSON.stringify(t)??""}catch{}return{value:e,type:"string"}}}}
/**
 * Captures a log event and sends it to Sentry.
 *
 * @param log - The log event to capture.
 * @param scope - A scope. Uses the current scope if not provided.
 * @param client - A client. Uses the current client if not provided.
 *
 * @experimental This method will experience breaking changes. This is not yet part of
 * the stable Sentry SDK API and can be changed or removed without warning.
 */function No(e,r=Wt(),s=Ft()){if(!r){t&&j.warn("No client available to capture log.");return}const{_experiments:o,release:i,environment:a}=r.getOptions();const{enableLogs:c=false,beforeSendLog:u}=o??{};if(!c){t&&j.warn("logging option not enabled, log will not be captured.");return}const[,l]=ko(r,s);const p={...e.attributes};i&&(p["sentry.release"]=i);a&&(p["sentry.environment"]=a);const{sdk:f}=r.getSdkMetadata()??{};if(f){p["sentry.sdk.name"]=f.name;p["sentry.sdk.version"]=f.version}const h=e.message;if(d(h)){const{__sentry_template_string__:t,__sentry_template_values__:e=[]}=h;p["sentry.message.template"]=t;e.forEach(((t,e)=>{p[`sentry.message.parameter.${e}`]=t}))}const m=It(s);m&&(p["sentry.trace.parent_span_id"]=m.spanContext().spanId);const g={...e,attributes:p};r.emit("beforeCaptureLog",g);const _=u?u(g):g;if(!_){r.recordDroppedEvent("before_send","log_item",1);t&&j.warn("beforeSendLog returned null, log will not be captured.");return}const{level:y,message:v,attributes:b={},severityNumber:S}=_;const E={timestamp:mt(),level:y,body:v,trace_id:l?.trace_id,severity_number:S??To[y],attributes:Object.keys(b).reduce(((t,e)=>{t[e]=Po(b[e]);return t}),{})};const w=Do(r);if(w===void 0)n._sentryClientToLogBufferMap?.set(r,[E]);else{n._sentryClientToLogBufferMap?.set(r,[...w,E]);w.length>=Co&&Ro(r,w)}r.emit("afterCaptureLog",_)}
/**
 * Flushes the logs buffer to Sentry.
 *
 * @param client - A client.
 * @param maybeLogBuffer - A log buffer. Uses the log buffer for the given client if not provided.
 *
 * @experimental This method will experience breaking changes. This is not yet part of
 * the stable Sentry SDK API and can be changed or removed without warning.
 */function Ro(t,e){const r=e??Do(t)??[];if(r.length===0)return;const s=t.getOptions();const o=Oo(r,s._metadata,s.tunnel,t.getDsn());n._sentryClientToLogBufferMap?.set(t,[]);t.emit("flushLogs");t.sendEnvelope(o)}
/**
 * Returns the log buffer for a given client.
 *
 * Exported for testing purposes.
 *
 * @param client - The client to get the log buffer for.
 * @returns The log buffer for the given client.
 */function Do(t){return n._sentryClientToLogBufferMap?.get(t)}function jo(t,e){return t(e.stack||"",1)}function Mo(t,e){const n={type:e.name||e.constructor.name,value:e.message};const r=jo(t,e);r.length&&(n.stacktrace={frames:r});return n}function Lo(t){for(const e in t)if(Object.prototype.hasOwnProperty.call(t,e)){const n=t[e];if(n instanceof Error)return n}}function Fo(t){if("name"in t&&typeof t.name==="string"){let e=`'${t.name}' captured as exception`;"message"in t&&typeof t.message==="string"&&(e+=` with message '${t.message}'`);return e}if("message"in t&&typeof t.message==="string")return t.message;const e=Y(t);if(u(t))return`Event \`ErrorEvent\` captured as exception with message \`${t.message}\``;const n=Uo(t);return`${n&&n!=="Object"?`'${n}'`:"Object"} captured as exception with keys: ${e}`}function Uo(t){try{const e=Object.getPrototypeOf(t);return e?e.constructor.name:void 0}catch(t){}}function zo(t,e,n,r){if(a(n))return[n,void 0];e.synthetic=true;if(m(n)){const e=t?.getOptions().normalizeDepth;const s={__serialized__:Kn(n,e)};const o=Lo(n);if(o)return[o,s];const i=Fo(n);const a=r?.syntheticException||new Error(i);a.message=i;return[a,s]}const s=r?.syntheticException||new Error(n);s.message=`${n}`;return[s,void 0]}function qo(t,e,n,r){const s=r?.data&&r.data.mechanism;const o=s||{handled:true,type:"generic"};const[i,a]=zo(t,o,n,r);const c={exception:{values:[Mo(e,i)]}};a&&(c.extra=a);st(c,void 0,void 0);ot(c,o);return{...c,event_id:r?.event_id}}function Bo(t,e,n="info",r,s){const o={event_id:r?.event_id,level:n};if(s&&r?.syntheticException){const n=jo(t,r.syntheticException);if(n.length){o.exception={values:[{value:e,stacktrace:{frames:n}}]};ot(o,{synthetic:true})}}if(d(e)){const{__sentry_template_string__:t,__sentry_template_values__:n}=e;o.logentry={message:t,params:n};return o}o.message=e;return o}const Wo=5e3;class ServerRuntimeClient extends Client{
/**
   * Creates a new Edge SDK instance.
   * @param options Configuration options for this SDK.
   */
constructor(t){In();super(t);this._logWeight=0;if(this._options._experiments?.enableLogs){const t=this;t.on("flushLogs",(()=>{t._logWeight=0;clearTimeout(t._logFlushIdleTimeout)}));t.on("afterCaptureLog",(e=>{t._logWeight+=Go(e);t._logWeight>=8e5?Ro(t):t._logFlushIdleTimeout=setTimeout((()=>{Ro(t)}),Wo)}));t.on("flush",(()=>{Ro(t)}))}}eventFromException(t,e){const n=qo(this,this._options.stackParser,t,e);n.level="error";return Qr(n)}eventFromMessage(t,e="info",n){return Qr(Bo(this._options.stackParser,t,e,n,this._options.attachStacktrace))}captureException(t,e,n){Jo(e);return super.captureException(t,e,n)}captureEvent(t,e,n){const r=!t.type&&t.exception?.values&&t.exception.values.length>0;r&&Jo(e);return super.captureEvent(t,e,n)}
/**
   * Create a cron monitor check in and send it to Sentry.
   *
   * @param checkIn An object that describes a check in.
   * @param upsertMonitorConfig An optional object that describes a monitor config. Use this if you want
   * to create a monitor automatically when sending a check in.
   */captureCheckIn(e,n,r){const s="checkInId"in e&&e.checkInId?e.checkInId:et();if(!this._isEnabled()){t&&j.warn("SDK not enabled, will not capture check-in.");return s}const o=this.getOptions();const{release:i,environment:a,tunnel:c}=o;const u={check_in_id:s,monitor_slug:e.monitorSlug,status:e.status,release:i,environment:a};"duration"in e&&(u.duration=e.duration);n&&(u.monitor_config={schedule:n.schedule,checkin_margin:n.checkinMargin,max_runtime:n.maxRuntime,timezone:n.timezone,failure_issue_threshold:n.failureIssueThreshold,recovery_threshold:n.recoveryThreshold});const[l,p]=ko(this,r);p&&(u.contexts={trace:p});const f=Io(u,l,this.getSdkMetadata(),c,this.getDsn());t&&j.info("Sending checkin:",e.monitorSlug,e.status);this.sendEnvelope(f);return s}_prepareEvent(t,e,n,r){this._options.platform&&(t.platform=t.platform||this._options.platform);this._options.runtime&&(t.contexts={...t.contexts,runtime:t.contexts?.runtime||this._options.runtime});this._options.serverName&&(t.server_name=t.server_name||this._options.serverName);return super._prepareEvent(t,e,n,r)}}function Jo(t){const e=Ut().getScopeData().sdkProcessingMetadata.requestSession;if(e){const n=t?.mechanism?.handled??true;n&&e.status!=="crashed"?e.status="errored":n||(e.status="crashed")}}
/**
 * Estimate the size of a log in bytes.
 *
 * @param log - The log to estimate the size of.
 * @returns The estimated size of the log in bytes.
 */function Go(t){let e=0;t.message&&(e+=t.message.length*2);t.attributes&&Object.values(t.attributes).forEach((t=>{Array.isArray(t)?e+=t.length*Zo(t[0]):h(t)?e+=Zo(t):e+=100}));return e}function Zo(t){return typeof t==="string"?t.length*2:typeof t==="number"?8:typeof t==="boolean"?4:0}
/**
 * Internal function to create a new SDK client instance. The client is
 * installed and then bound to the current scope.
 *
 * @param clientClass The client class to instantiate.
 * @param options Options to pass to the client.
 */function Ho(e,n){n.debug===true&&(t?j.enable():R((()=>{console.warn("[Sentry] Cannot initialize SDK with `debug` option using a non-debug bundle.")})));const r=Ft();r.update(n.initialScope);const s=new e(n);Yo(s);s.init();return s}function Yo(t){Ft().setClient(t)}const Ko=Symbol.for("SentryBufferFullError");
/**
 * Creates an new PromiseBuffer object with the specified limit
 * @param limit max number of promises that can be stored in the buffer
 */function Vo(t){const e=[];function n(){return t===void 0||e.length<t}
/**
   * Remove a promise from the queue.
   *
   * @param task Can be any PromiseLike<T>
   * @returns Removed promise.
   */function r(t){return e.splice(e.indexOf(t),1)[0]||Promise.resolve(void 0)}
/**
   * Add a promise (representing an in-flight action) to the queue, and set it to remove itself on fulfillment.
   *
   * @param taskProducer A function producing any PromiseLike<T>; In previous versions this used to be `task:
   *        PromiseLike<T>`, but under that model, Promises were instantly created on the call-site and their executor
   *        functions therefore ran immediately. Thus, even if the buffer was full, the action still happened. By
   *        requiring the promise to be wrapped in a function, we can defer promise creation until after the buffer
   *        limit check.
   * @returns The original promise.
   */function s(t){if(!n())return ts(Ko);const s=t();e.indexOf(s)===-1&&e.push(s);void s.then((()=>r(s))).then(null,(()=>r(s).then(null,(()=>{}))));return s}
/**
   * Wait for all promises in the queue to resolve or for timeout to expire, whichever comes first.
   *
   * @param timeout The time, in ms, after which to resolve to `false` if the queue is still non-empty. Passing `0` (or
   * not passing anything) will make the promise wait as long as it takes for the queue to drain before resolving to
   * `true`.
   * @returns A promise which will resolve to `true` if the queue is already empty or drains before the timeout, and
   * `false` otherwise
   */function o(t){return new SyncPromise(((n,r)=>{let s=e.length;if(!s)return n(true);const o=setTimeout((()=>{t&&t>0&&n(false)}),t);e.forEach((t=>{void Qr(t).then((()=>{if(! --s){clearTimeout(o);n(true)}}),r)}))}))}return{$:e,add:s,drain:o}}const Xo=6e4;
/**
 * Extracts Retry-After value from the request header or returns default value
 * @param header string representation of 'Retry-After' header
 * @param now current unix timestamp
 *
 */function Qo(t,e=Date.now()){const n=parseInt(`${t}`,10);if(!isNaN(n))return n*1e3;const r=Date.parse(`${t}`);return isNaN(r)?Xo:r-e}function ti(t,e){return t[e]||t.all||0}function ei(t,e,n=Date.now()){return ti(t,e)>n}function ni(t,{statusCode:e,headers:n},r=Date.now()){const s={...t};const o=n?.["x-sentry-rate-limits"];const i=n?.["retry-after"];if(o)for(const t of o.trim().split(",")){const[e,n,,,o]=t.split(":",5);const i=parseInt(e,10);const a=(isNaN(i)?60:i)*1e3;if(n)for(const t of n.split(";"))t==="metric_bucket"&&o&&!o.split(";").includes("custom")||(s[t]=r+a);else s.all=r+a}else i?s.all=r+Qo(i,r):e===429&&(s.all=r+6e4);return s}const ri=64;
/**
 * Creates an instance of a Sentry `Transport`
 *
 * @param options
 * @param makeRequest
 */function si(e,n,r=Vo(e.bufferSize||ri)){let s={};const o=t=>r.drain(t);function i(o){const i=[];ir(o,((t,n)=>{const r=gr(n);ei(s,r)?e.recordDroppedEvent("ratelimit_backoff",r):i.push(t)}));if(i.length===0)return Qr({});const a=sr(o[0],i);const c=t=>{ir(a,((n,r)=>{e.recordDroppedEvent(t,gr(r))}))};const u=()=>n({body:lr(a)}).then((e=>{e.statusCode!==void 0&&(e.statusCode<200||e.statusCode>=300)&&t&&j.warn(`Sentry responded with status code ${e.statusCode} to sent event.`);s=ni(s,e);return e}),(e=>{c("network_error");t&&j.error("Encountered error running transport request:",e);throw e}));return r.add(u).then((t=>t),(e=>{if(e===Ko){t&&j.error("Skipped sending event because buffer is full.");c("queue_overflow");return Qr({})}throw e}))}return{send:i,flush:o}}const oi=100;const ii=5e3;const ai=36e5;
/**
 * Wraps a transport and stores and retries events when they fail to send.
 *
 * @param createTransport The transport to wrap.
 */function ci(e){function n(...e){t&&j.info("[Offline]:",...e)}return t=>{const r=e(t);if(!t.createStore)throw new Error("No `createStore` function was provided");const s=t.createStore(t);let o=ii;let i;function a(e,n,r){return!ar(e,["client_report"])&&(!t.shouldStore||t.shouldStore(e,n,r))}function c(t){i&&clearTimeout(i);i=setTimeout((async()=>{i=void 0;const t=await s.shift();if(t){n("Attempting to send previously queued event");t[0].sent_at=(new Date).toISOString();void l(t,true).catch((t=>{n("Failed to retry sending",t)}))}}),t);typeof i!=="number"&&i.unref&&i.unref()}function u(){if(!i){c(o);o=Math.min(o*2,ai)}}async function l(e,i=false){if(!i&&ar(e,["replay_event","replay_recording"])){await s.push(e);c(oi);return{}}try{if(t.shouldSend&&await t.shouldSend(e)===false)throw new Error("Envelope not sent because `shouldSend` callback returned false");const n=await r.send(e);let s=oi;if(n)if(n.headers?.["retry-after"])s=Qo(n.headers["retry-after"]);else if(n.headers?.["x-sentry-rate-limits"])s=6e4;else if((n.statusCode||0)>=400)return n;c(s);o=ii;return n}catch(t){if(await a(e,t,o)){i?await s.unshift(e):await s.push(e);u();n("Error sending. Event queued.",t);return{}}throw t}}t.flushAtStartup&&u();return{send:l,flush:t=>{if(t===void 0){o=ii;c(oi)}return r.flush(t)}}}}function ui(t,e){let n;ir(t,((t,r)=>{e.includes(r)&&(n=Array.isArray(t)?t[1]:void 0);return!!n}));return n}function li(t,e){return n=>{const r=t(n);return{...r,send:async t=>{const n=ui(t,["event","transaction","profile","replay_event"]);n&&(n.release=e);return r.send(t)}}}}function pi(t,e){return sr(e?{...t[0],dsn:e}:t[0],t[1])}function fi(t,e){return n=>{const r=t(n);const s=new Map;function o(e,r){const o=r?`${e}:${r}`:e;let i=s.get(o);if(!i){const a=Jn(e);if(!a)return;const c=Vs(a,n.tunnel);i=r?li(t,r)({...n,url:c}):t({...n,url:c});s.set(o,i)}return[e,i]}async function i(t){function n(e){const n=e?.length?e:["event"];return ui(t,n)}const s=e({envelope:t,getEvent:n}).map((t=>typeof t==="string"?o(t,void 0):o(t.dsn,t.release))).filter((t=>!!t));const i=s.length?s:[["",r]];const a=await Promise.all(i.map((([e,n])=>n.send(pi(t,e)))));return a[0]}async function a(t){const e=[...s.values(),r];const n=await Promise.all(e.map((e=>e.flush(t))));return n.every((t=>t))}return{send:i,flush:a}}}
/**
 * Checks whether given url points to Sentry server
 *
 * @param url url to verify
 */function di(t,e){const n=e?.getDsn();const r=e?.getOptions().tunnel;return mi(t,n)||hi(t,r)}function hi(t,e){return!!e&&gi(t)===gi(e)}function mi(t,e){return!!e&&t.includes(e.host)}function gi(t){return t[t.length-1]==="/"?t.slice(0,-1):t}
/**
 * Tagged template function which returns parameterized representation of the message
 * For example: parameterize`This is a log statement with ${x} and ${y} params`, would return:
 * "__sentry_template_string__": 'This is a log statement with %s and %s params',
 * "__sentry_template_values__": ['first', 'second']
 *
 * @param strings An array of string values splitted between expressions
 * @param values Expressions extracted from template string
 *
 * @returns A `ParameterizedString` object that can be passed into `captureMessage` or Sentry.logger.X methods.
 */function _i(t,...e){const n=new String(String.raw(t,...e));n.__sentry_template_string__=t.join("\0").replace(/%/g,"%%").replace(/\0/g,"%s");n.__sentry_template_values__=e;return n}
/**
 * Tagged template function which returns parameterized representation of the message.
 *
 * @param strings An array of string values splitted between expressions
 * @param values Expressions extracted from template string
 * @returns A `ParameterizedString` object that can be passed into `captureMessage` or Sentry.logger.X methods.
 */const yi=_i;function vi(t){t.user?.ip_address===void 0&&(t.user={...t.user,ip_address:"{{auto}}"})}function bi(t){"aggregates"in t?t.attrs?.ip_address===void 0&&(t.attrs={...t.attrs,ip_address:"{{auto}}"}):t.ipAddress===void 0&&(t.ipAddress="{{auto}}")}
/**
 * A builder for the SDK metadata in the options for the SDK initialization.
 *
 * Note: This function is identical to `buildMetadata` in Remix and NextJS and SvelteKit.
 * We don't extract it for bundle size reasons.
 * @see https://github.com/getsentry/sentry-javascript/pull/7404
 * @see https://github.com/getsentry/sentry-javascript/pull/4196
 *
 * If you make changes to this function consider updating the others as well.
 *
 * @param options SDK options object that gets mutated
 * @param names list of package names
 */function Si(t,n,r=[n],s="npm"){const o=t._metadata||{};o.sdk||(o.sdk={name:`sentry.javascript.${n}`,packages:r.map((t=>({name:`${s}:@sentry/${t}`,version:e}))),version:e});t._metadata=o}
/**
 * Extracts trace propagation data from the current span or from the client's scope (via transaction or propagation
 * context) and serializes it to `sentry-trace` and `baggage` values to strings. These values can be used to propagate
 * a trace via our tracing Http headers or Html `<meta>` tags.
 *
 * This function also applies some validation to the generated sentry-trace and baggage values to ensure that
 * only valid strings are returned.
 *
 * @returns an object with the tracing data values. The object keys are the name of the tracing key to be used as header
 * or meta tag name.
 */function Ei(t={}){const e=Wt();if(!zs()||!e)return{};const n=r();const s=Lt(n);if(s.getTraceData)return s.getTraceData(t);const o=Ft();const i=t.span||Xe();const a=i?Me(i):wi(o);const c=i?Dn(i):Rn(e,o);const u=we(c);const l=$e.test(a);if(!l){j.warn("Invalid sentry-trace data. Cannot generate trace data");return{}}return{"sentry-trace":a,baggage:u}}function wi(t){const{traceId:e,sampled:n,propagationSpanId:r}=t.getPropagationContext();return Oe(e,r,n)}function xi(){return Object.entries(Ei()).map((([t,e])=>`<meta name="${t}" content="${e}"/>`)).join("\n")}function ki(t){const e={};try{t.forEach(((t,n)=>{typeof t==="string"&&(e[n]=t)}))}catch{}return e}function Ii(t){const e=Object.create(null);try{Object.entries(t).forEach((([t,n])=>{typeof n==="string"&&(e[t]=n)}))}catch{}return e}function $i(t){const e=ki(t.headers);return{method:t.method,url:t.url,query_string:Oi(t.url),headers:e}}function Ti(t){const e=t.headers||{};const n=typeof e.host==="string"?e.host:void 0;const r=t.protocol||(t.socket?.encrypted?"https":"http");const s=t.url||"";const o=Ai({url:s,host:n,protocol:r});const i=t.body||void 0;const a=t.cookies;return{url:o,method:t.method,query_string:Oi(s),headers:Ii(e),cookies:a,data:i}}function Ai({url:t,protocol:e,host:n}){return t?.startsWith("http")?t:t&&n?`${e}://${n}${t}`:void 0}function Oi(t){if(t)try{const e=new URL(t,"http://s.io").search.slice(1);return e.length?e:void 0}catch{return}}const Ci=100;function Pi(t,e){const n=Wt();const r=Ut();if(!n)return;const{beforeBreadcrumb:s=null,maxBreadcrumbs:o=Ci}=n.getOptions();if(o<=0)return;const i=dt();const a={timestamp:i,...t};const c=s?R((()=>s(a,e))):a;if(c!==null){n.emit&&n.emit("beforeAddBreadcrumb",c,e);r.addBreadcrumb(c,o)}}let Ni;const Ri="FunctionToString";const Di=new WeakMap;const ji=()=>({name:Ri,setupOnce(){Ni=Function.prototype.toString;try{Function.prototype.toString=function(...t){const e=J(this);const n=Di.has(Wt())&&e!==void 0?e:this;return Ni.apply(n,t)}}catch{}},setup(t){Di.set(t,true)}});const Mi=io(ji);const Li=[/^Script error\.?$/,/^Javascript error: Script error\.? on line 0$/,/^ResizeObserver loop completed with undelivered notifications.$/,/^Cannot redefine property: googletag$/,/^Can't find variable: gmo$/,/^undefined is not an object \(evaluating 'a\.[A-Z]'\)$/,'can\'t redefine non-configurable property "solana"',"vv().getRestrictions is not a function. (In 'vv().getRestrictions(1,a)', 'vv().getRestrictions' is undefined)","Can't find variable: _AutofillCallbackHandler",/^Non-Error promise rejection captured with value: Object Not Found Matching Id:\d+, MethodName:simulateEvent, ParamCount:\d+$/,/^Java exception was raised during method invocation$/];const Fi="EventFilters";
/**
 * An integration that filters out events (errors and transactions) based on:
 *
 * - (Errors) A curated list of known low-value or irrelevant errors (see {@link DEFAULT_IGNORE_ERRORS})
 * - (Errors) A list of error messages or urls/filenames passed in via
 *   - Top level Sentry.init options (`ignoreErrors`, `denyUrls`, `allowUrls`)
 *   - The same options passed to the integration directly via @param options
 * - (Transactions/Spans) A list of root span (transaction) names passed in via
 *   - Top level Sentry.init option (`ignoreTransactions`)
 *   - The same option passed to the integration directly via @param options
 *
 * Events filtered by this integration will not be sent to Sentry.
 */const Ui=io(((t={})=>{let e;return{name:Fi,setup(n){const r=n.getOptions();e=qi(t,r)},processEvent(n,r,s){if(!e){const n=s.getOptions();e=qi(t,n)}return Bi(n,e)?null:n}}}));
/**
 * An integration that filters out events (errors and transactions) based on:
 *
 * - (Errors) A curated list of known low-value or irrelevant errors (see {@link DEFAULT_IGNORE_ERRORS})
 * - (Errors) A list of error messages or urls/filenames passed in via
 *   - Top level Sentry.init options (`ignoreErrors`, `denyUrls`, `allowUrls`)
 *   - The same options passed to the integration directly via @param options
 * - (Transactions/Spans) A list of root span (transaction) names passed in via
 *   - Top level Sentry.init option (`ignoreTransactions`)
 *   - The same option passed to the integration directly via @param options
 *
 * Events filtered by this integration will not be sent to Sentry.
 *
 * @deprecated this integration was renamed and will be removed in a future major version.
 * Use `eventFiltersIntegration` instead.
 */const zi=io(((t={})=>({...Ui(t),name:"InboundFilters"})));function qi(t={},e={}){return{allowUrls:[...t.allowUrls||[],...e.allowUrls||[]],denyUrls:[...t.denyUrls||[],...e.denyUrls||[]],ignoreErrors:[...t.ignoreErrors||[],...e.ignoreErrors||[],...t.disableErrorDefaults?[]:Li],ignoreTransactions:[...t.ignoreTransactions||[],...e.ignoreTransactions||[]]}}function Bi(e,n){if(e.type){if(e.type==="transaction"&&Ji(e,n.ignoreTransactions)){t&&j.warn(`Event dropped due to being matched by \`ignoreTransactions\` option.\nEvent: ${rt(e)}`);return true}}else{if(Wi(e,n.ignoreErrors)){t&&j.warn(`Event dropped due to being matched by \`ignoreErrors\` option.\nEvent: ${rt(e)}`);return true}if(Ki(e)){t&&j.warn(`Event dropped due to not having an error message, error type or stacktrace.\nEvent: ${rt(e)}`);return true}if(Gi(e,n.denyUrls)){t&&j.warn(`Event dropped due to being matched by \`denyUrls\` option.\nEvent: ${rt(e)}.\nUrl: ${Yi(e)}`);return true}if(!Zi(e,n.allowUrls)){t&&j.warn(`Event dropped due to not being matched by \`allowUrls\` option.\nEvent: ${rt(e)}.\nUrl: ${Yi(e)}`);return true}}return false}function Wi(t,e){return!!e?.length&&ao(t).some((t=>z(t,e)))}function Ji(t,e){if(!e?.length)return false;const n=t.transaction;return!!n&&z(n,e)}function Gi(t,e){if(!e?.length)return false;const n=Yi(t);return!!n&&z(n,e)}function Zi(t,e){if(!e?.length)return true;const n=Yi(t);return!n||z(n,e)}function Hi(t=[]){for(let e=t.length-1;e>=0;e--){const n=t[e];if(n&&n.filename!=="<anonymous>"&&n.filename!=="[native code]")return n.filename||null}return null}function Yi(e){try{const t=[...e.exception?.values??[]].reverse().find((t=>t.mechanism?.parent_id===void 0&&t.stacktrace?.frames?.length));const n=t?.stacktrace?.frames;return n?Hi(n):null}catch(n){t&&j.error(`Cannot extract url for event ${rt(e)}`);return null}}function Ki(t){return!!t.exception?.values?.length&&(!t.message&&!t.exception.values.some((t=>t.stacktrace||t.type&&t.type!=="Error"||t.value)))}function Vi(t,e,n,r,s,o){if(!s.exception?.values||!o||!S(o.originalException,Error))return;const i=s.exception.values.length>0?s.exception.values[s.exception.values.length-1]:void 0;i&&(s.exception.values=Xi(t,e,r,o.originalException,n,s.exception.values,i,0))}function Xi(t,e,n,r,s,o,i,a){if(o.length>=n+1)return o;let c=[...o];if(S(r[s],Error)){Qi(i,a);const o=t(e,r[s]);const u=c.length;ta(o,s,u,a);c=Xi(t,e,n,r[s],s,[o,...c],o,u)}Array.isArray(r.errors)&&r.errors.forEach(((r,o)=>{if(S(r,Error)){Qi(i,a);const u=t(e,r);const l=c.length;ta(u,`errors[${o}]`,l,a);c=Xi(t,e,n,r,s,[u,...c],u,l)}}));return c}function Qi(t,e){t.mechanism=t.mechanism||{type:"generic",handled:true};t.mechanism={...t.mechanism,...t.type==="AggregateError"&&{is_exception_group:true},exception_id:e}}function ta(t,e,n,r){t.mechanism=t.mechanism||{type:"generic",handled:true};t.mechanism={...t.mechanism,type:"chained",source:e,exception_id:n,parent_id:r}}const ea="cause";const na=5;const ra="LinkedErrors";const sa=(t={})=>{const e=t.limit||na;const n=t.key||ea;return{name:ra,preprocessEvent(t,r,s){const o=s.getOptions();Vi(Mo,o.stackParser,n,e,t,r)}}};const oa=io(sa);const ia=new Map;const aa=new Set;function ca(t){if(n._sentryModuleMetadata)for(const e of Object.keys(n._sentryModuleMetadata)){const r=n._sentryModuleMetadata[e];if(aa.has(e))continue;aa.add(e);const s=t(e);for(const t of s.reverse())if(t.filename){ia.set(t.filename,r);break}}}function ua(t,e){ca(t);return ia.get(e)}function la(t,e){try{e.exception.values.forEach((e=>{if(e.stacktrace)for(const n of e.stacktrace.frames||[]){if(!n.filename||n.module_metadata)continue;const e=ua(t,n.filename);e&&(n.module_metadata=e)}}))}catch(t){}}function pa(t){try{t.exception.values.forEach((t=>{if(t.stacktrace)for(const e of t.stacktrace.frames||[])delete e.module_metadata}))}catch(t){}}const fa=io((()=>({name:"ModuleMetadata",setup(t){t.on("beforeEnvelope",(t=>{ir(t,((t,e)=>{if(e==="event"){const e=Array.isArray(t)?t[1]:void 0;if(e){pa(e);t[1]=e}}}))}));t.on("applyFrameMetadata",(e=>{if(e.type)return;const n=t.getOptions().stackParser;la(n,e)}))}})));function da(t){const e={};let n=0;while(n<t.length){const r=t.indexOf("=",n);if(r===-1)break;let s=t.indexOf(";",n);if(s===-1)s=t.length;else if(s<r){n=t.lastIndexOf(";",r-1)+1;continue}const o=t.slice(n,r).trim();if(void 0===e[o]){let n=t.slice(r+1,s).trim();n.charCodeAt(0)===34&&(n=n.slice(1,-1));try{e[o]=n.indexOf("%")!==-1?decodeURIComponent(n):n}catch(t){e[o]=n}}n=s+1}return e}const ha=["X-Client-IP","X-Forwarded-For","Fly-Client-IP","CF-Connecting-IP","Fastly-Client-Ip","True-Client-Ip","X-Real-IP","X-Cluster-Client-IP","X-Forwarded","Forwarded-For","Forwarded","X-Vercel-Forwarded-For"];function ma(t){const e=ha.map((e=>{const n=t[e];const r=Array.isArray(n)?n.join(";"):n;return e==="Forwarded"?ga(r):r?.split(",").map((t=>t.trim()))}));const n=e.reduce(((t,e)=>e?t.concat(e):t),[]);const r=n.find((t=>t!==null&&_a(t)));return r||null}function ga(t){if(!t)return null;for(const e of t.split(";"))if(e.startsWith("for="))return e.slice(4);return null}function _a(t){const e=/(?:^(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}$)|(?:^(?:(?:[a-fA-F\d]{1,4}:){7}(?:[a-fA-F\d]{1,4}|:)|(?:[a-fA-F\d]{1,4}:){6}(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|:[a-fA-F\d]{1,4}|:)|(?:[a-fA-F\d]{1,4}:){5}(?::(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,2}|:)|(?:[a-fA-F\d]{1,4}:){4}(?:(?::[a-fA-F\d]{1,4}){0,1}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,3}|:)|(?:[a-fA-F\d]{1,4}:){3}(?:(?::[a-fA-F\d]{1,4}){0,2}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,4}|:)|(?:[a-fA-F\d]{1,4}:){2}(?:(?::[a-fA-F\d]{1,4}){0,3}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,5}|:)|(?:[a-fA-F\d]{1,4}:){1}(?:(?::[a-fA-F\d]{1,4}){0,4}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,6}|:)|(?::(?:(?::[a-fA-F\d]{1,4}){0,5}:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:\\.(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3}|(?::[a-fA-F\d]{1,4}){1,7}|:)))(?:%[0-9a-zA-Z]{1,})?$)/;return e.test(t)}const ya={cookies:true,data:true,headers:true,query_string:true,url:true};const va="RequestData";const ba=(t={})=>{const e={...ya,...t.include};return{name:va,processEvent(t,n,r){const{sdkProcessingMetadata:s={}}=t;const{normalizedRequest:o,ipAddress:i}=s;const a={...e,ip:e.ip??r.getOptions().sendDefaultPii};o&&Ea(t,o,{ipAddress:i},a);return t}}};const Sa=io(ba);function Ea(t,e,n,r){t.request={...t.request,...wa(e,r)};if(r.ip){const r=e.headers&&ma(e.headers)||n.ipAddress;r&&(t.user={...t.user,ip_address:r})}}function wa(t,e){const n={};const r={...t.headers};if(e.headers){n.headers=r;e.cookies||delete r.cookie;e.ip||ha.forEach((t=>{delete r[t]}))}n.method=t.method;e.url&&(n.url=t.url);if(e.cookies){const e=t.cookies||(r?.cookie?da(r.cookie):void 0);n.cookies=e||{}}e.query_string&&(n.query_string=t.query_string);e.data&&(n.data=t.data);return n}function xa(t){const e="console";mn(e,t);_n(e,ka)}function ka(){"console"in n&&P.forEach((function(t){t in n.console&&q(n.console,t,(function(e){N[t]=e;return function(...e){const r={args:e,level:t};yn("console",r);const s=N[t];s?.apply(n.console,e)}}))}))}
/**
 * Converts a string-based level into a `SeverityLevel`, normalizing it along the way.
 *
 * @param level String representation of desired `SeverityLevel`.
 * @returns The `SeverityLevel` corresponding to the given string, or 'log' if the string isn't a valid level.
 */function Ia(t){return t==="warn"?"warning":["fatal","error","warning","log","info","debug"].includes(t)?t:"log"}const $a="CaptureConsole";const Ta=(t={})=>{const e=t.levels||P;const r=t.handled??true;return{name:$a,setup(t){"console"in n&&xa((({args:n,level:s})=>{Wt()===t&&e.includes(s)&&Oa(n,s,r)}))}}};const Aa=io(Ta);function Oa(t,e,n){const r={level:Ia(e),extra:{arguments:t}};qt((s=>{s.addEventProcessor((t=>{t.logger="console";ot(t,{handled:n,type:"console"});return t}));if(e==="assert"){if(!t[0]){const e=`Assertion failed: ${F(t.slice(1)," ")||"console.assert"}`;s.setExtra("arguments",t.slice(1));$s(e,r)}return}const o=t.find((t=>t instanceof Error));if(o){Is(o,r);return}const i=F(t," ");$s(i,r)}))}const Ca="Dedupe";const Pa=()=>{let e;return{name:Ca,processEvent(n){if(n.type)return n;try{if(Ra(n,e)){t&&j.warn("Event dropped due to being a duplicate of previously captured event.");return null}}catch(t){}return e=n}}};const Na=io(Pa);function Ra(t,e){return!!e&&(!!Da(t,e)||!!ja(t,e))}function Da(t,e){const n=t.message;const r=e.message;return!(!n&&!r)&&(!(n&&!r||!n&&r)&&(n===r&&(!!La(t,e)&&!!Ma(t,e))))}function ja(t,e){const n=Fa(e);const r=Fa(t);return!(!n||!r)&&(n.type===r.type&&n.value===r.value&&(!!La(t,e)&&!!Ma(t,e)))}function Ma(t,e){let n=fn(t);let r=fn(e);if(!n&&!r)return true;if(n&&!r||!n&&r)return false;n;r;if(r.length!==n.length)return false;for(let t=0;t<r.length;t++){const e=r[t];const s=n[t];if(e.filename!==s.filename||e.lineno!==s.lineno||e.colno!==s.colno||e.function!==s.function)return false}return true}function La(t,e){let n=t.fingerprint;let r=e.fingerprint;if(!n&&!r)return true;if(n&&!r||!n&&r)return false;n;r;try{return!!(n.join("")===r.join(""))}catch(t){return false}}function Fa(t){return t.exception?.values&&t.exception.values[0]}const Ua="ExtraErrorData";const za=(t={})=>{const{depth:e=3,captureErrorCause:n=true}=t;return{name:Ua,processEvent(t,r,s){const{maxValueLength:o=250}=s.getOptions();return Ba(t,r,e,n,o)}}};const qa=io(za);function Ba(t,e={},n,r,s){if(!e.originalException||!a(e.originalException))return t;const o=e.originalException.name||e.originalException.constructor.name;const i=Wa(e.originalException,r,s);if(i){const e={...t.contexts};const r=Yn(i,n);if(m(r)){B(r,"__sentry_skip_normalization__",true);e[o]=r}return{...t,contexts:e}}return t}function Wa(e,n,r){try{const t=["name","message","stack","line","column","fileName","lineNumber","columnNumber","toJSON"];const s={};for(const n of Object.keys(e)){if(t.indexOf(n)!==-1)continue;const o=e[n];s[n]=a(o)||typeof o==="string"?M(`${o}`,r):o}n&&e.cause!==void 0&&(s.cause=a(e.cause)?e.cause.toString():e.cause);if(typeof e.toJSON==="function"){const t=e.toJSON();for(const e of Object.keys(t)){const n=t[e];s[e]=a(n)?n.toString():n}}return s}catch(e){t&&j.error("Unable to extract extra data from the Error object:",e)}return null}function Ja(t,e){let n=0;for(let e=t.length-1;e>=0;e--){const r=t[e];if(r===".")t.splice(e,1);else if(r===".."){t.splice(e,1);n++}else if(n){t.splice(e,1);n--}}if(e)for(;n--;n)t.unshift("..");return t}const Ga=/^(\S+:\\|\/?)([\s\S]*?)((?:\.{1,2}|[^/\\]+?|)(\.[^./\\]*|))(?:[/\\]*)$/;function Za(t){const e=t.length>1024?`<truncated>${t.slice(-1024)}`:t;const n=Ga.exec(e);return n?n.slice(1):[]}function Ha(...t){let e="";let n=false;for(let r=t.length-1;r>=-1&&!n;r--){const s=r>=0?t[r]:"/";if(s){e=`${s}/${e}`;n=s.charAt(0)==="/"}}e=Ja(e.split("/").filter((t=>!!t)),!n).join("/");return(n?"/":"")+e||"."}function Ya(t){let e=0;for(;e<t.length;e++)if(t[e]!=="")break;let n=t.length-1;for(;n>=0;n--)if(t[n]!=="")break;return e>n?[]:t.slice(e,n-e+1)}function Ka(t,e){t=Ha(t).slice(1);e=Ha(e).slice(1);const n=Ya(t.split("/"));const r=Ya(e.split("/"));const s=Math.min(n.length,r.length);let o=s;for(let t=0;t<s;t++)if(n[t]!==r[t]){o=t;break}let i=[];for(let t=o;t<n.length;t++)i.push("..");i=i.concat(r.slice(o));return i.join("/")}function Va(t){const e=Xa(t);const n=t.slice(-1)==="/";let r=Ja(t.split("/").filter((t=>!!t)),!e).join("/");r||e||(r=".");r&&n&&(r+="/");return(e?"/":"")+r}function Xa(t){return t.charAt(0)==="/"}function Qa(...t){return Va(t.join("/"))}function tc(t){const e=Za(t);const n=e[0]||"";let r=e[1];if(!n&&!r)return".";r&&(r=r.slice(0,r.length-1));return n+r}function ec(t,e){let n=Za(t)[2]||"";e&&n.slice(e.length*-1)===e&&(n=n.slice(0,n.length-e.length));return n}const nc="RewriteFrames";const rc=io(((t={})=>{const e=t.root;const r=t.prefix||"app:///";const s="window"in n&&!!n.window;const o=t.iteratee||sc({isBrowser:s,root:e,prefix:r});function i(t){try{return{...t,exception:{...t.exception,values:t.exception.values.map((t=>({...t,...t.stacktrace&&{stacktrace:a(t.stacktrace)}})))}}}catch(e){return t}}function a(t){return{...t,frames:t?.frames&&t.frames.map((t=>o(t)))}}return{name:nc,processEvent(t){let e=t;t.exception&&Array.isArray(t.exception.values)&&(e=i(e));return e}}}));function sc({isBrowser:t,root:e,prefix:n}){return r=>{if(!r.filename)return r;const s=/^[a-zA-Z]:\\/.test(r.filename)||r.filename.includes("\\")&&!r.filename.includes("/");const o=/^\//.test(r.filename);if(t){if(e){const t=r.filename;t.indexOf(e)===0&&(r.filename=t.replace(e,n))}}else if(s||o){const t=s?r.filename.replace(/^[a-zA-Z]:/,"").replace(/\\/g,"/"):r.filename;const o=e?Ka(e,t):ec(t);r.filename=`${n}${o}`}return r}}const oc=["reauthenticate","signInAnonymously","signInWithOAuth","signInWithIdToken","signInWithOtp","signInWithPassword","signInWithSSO","signOut","signUp","verifyOtp"];const ic=["createUser","deleteUser","listUsers","getUserById","updateUserById","inviteUserByEmail"];const ac={eq:"eq",neq:"neq",gt:"gt",gte:"gte",lt:"lt",lte:"lte",like:"like","like(all)":"likeAllOf","like(any)":"likeAnyOf",ilike:"ilike","ilike(all)":"ilikeAllOf","ilike(any)":"ilikeAnyOf",is:"is",in:"in",cs:"contains",cd:"containedBy",sr:"rangeGt",nxl:"rangeGte",sl:"rangeLt",nxr:"rangeLte",adj:"rangeAdjacent",ov:"overlaps",fts:"",plfts:"plain",phfts:"phrase",wfts:"websearch",not:"not"};const cc=["select","insert","upsert","update","delete"];function uc(t){try{t.__SENTRY_INSTRUMENTED__=true}catch{}}function lc(t){try{return t.__SENTRY_INSTRUMENTED__}catch{return false}}
/**
 * Extracts the database operation type from the HTTP method and headers
 * @param method - The HTTP method of the request
 * @param headers - The request headers
 * @returns The database operation type ('select', 'insert', 'upsert', 'update', or 'delete')
 */function pc(t,e={}){switch(t){case"GET":return"select";case"POST":return e.Prefer?.includes("resolution=")?"upsert":"insert";case"PATCH":return"update";case"DELETE":return"delete";default:return"<unknown-op>"}}
/**
 * Translates Supabase filter parameters into readable method names for tracing
 * @param key - The filter key from the URL search parameters
 * @param query - The filter value from the URL search parameters
 * @returns A string representation of the filter as a method call
 */function fc(t,e){if(e===""||e==="*")return"select(*)";if(t==="select")return`select(${e})`;if(t==="or"||t.endsWith(".or"))return`${t}${e}`;const[n,...r]=e.split(".");let s;s=n?.startsWith("fts")?"textSearch":n?.startsWith("plfts")?"textSearch[plain]":n?.startsWith("phfts")?"textSearch[phrase]":n?.startsWith("wfts")?"textSearch[websearch]":n&&ac[n]||"filter";return`${s}(${t}, ${r.join(".")})`}function dc(t,e=false){return new Proxy(t,{apply(n,r,s){return Cr({name:t.name,attributes:{[Kt]:"auto.db.supabase",[Yt]:`db.auth.${e?"admin.":""}${t.name}`}},(t=>Reflect.apply(n,r,s).then((e=>{if(e&&typeof e==="object"&&"error"in e&&e.error){t.setStatus({code:pe});Is(e.error,{mechanism:{handled:false}})}else t.setStatus({code:le});t.end();return e})).catch((e=>{t.setStatus({code:pe});t.end();Is(e,{mechanism:{handled:false}});throw e})).then(...s)))}})}function hc(t){const e=t.auth;if(e&&!lc(t.auth)){for(const n of oc){const r=e[n];r&&(typeof t.auth[n]==="function"&&(t.auth[n]=dc(r)))}for(const n of ic){const r=e.admin[n];r&&(typeof t.auth.admin[n]==="function"&&(t.auth.admin[n]=dc(r,true)))}uc(t.auth)}}function mc(t){if(!lc(t.prototype.from)){t.prototype.from=new Proxy(t.prototype.from,{apply(t,e,n){const r=Reflect.apply(t,e,n);const s=r.constructor;_c(s);return r}});uc(t.prototype.from)}}function gc(t){if(!lc(t.prototype.then)){t.prototype.then=new Proxy(t.prototype.then,{apply(t,e,n){const r=cc;const s=e;const o=pc(s.method,s.headers);if(!r.includes(o))return Reflect.apply(t,e,n);if(!s?.url?.pathname||typeof s.url.pathname!=="string")return Reflect.apply(t,e,n);const i=s.url.pathname.split("/");const a=i.length>0?i[i.length-1]:"";const c=`from(${a})`;const u=[];for(const[t,e]of s.url.searchParams.entries())u.push(fc(t,e));const l=Object.create(null);if(m(s.body))for(const[t,e]of Object.entries(s.body))l[t]=e;const p={"db.table":a,"db.schema":s.schema,"db.url":s.url.origin,"db.sdk":s.headers["X-Client-Info"],"db.system":"postgresql",[Kt]:"auto.db.supabase",[Yt]:`db.${o}`};u.length&&(p["db.query"]=u);Object.keys(l).length&&(p["db.body"]=l);return Cr({name:c,attributes:p},(r=>Reflect.apply(t,e,[]).then((t=>{if(r){t&&typeof t==="object"&&"status"in t&&de(r,t.status||500);r.end()}if(t.error){const e=new Error(t.error.message);t.error.code&&(e.code=t.error.code);t.error.details&&(e.details=t.error.details);const n={};u.length&&(n.query=u);Object.keys(l).length&&(n.body=l);Is(e,{contexts:{supabase:n}})}const e={type:"supabase",category:`db.${o}`,message:c};const n={};u.length&&(n.query=u);Object.keys(l).length&&(n.body=l);Object.keys(n).length&&(e.data=n);Pi(e);return t}),(t=>{if(r){de(r,500);r.end()}throw t})).then(...n)))}});uc(t.prototype.then)}}function _c(e){for(const n of cc)if(!lc(e.prototype[n])){e.prototype[n]=new Proxy(e.prototype[n],{apply(e,r,s){const o=Reflect.apply(e,r,s);const i=o.constructor;t&&j.log(`Instrumenting ${n} operation's PostgRESTFilterBuilder`);gc(i);return o}});uc(e.prototype[n])}}const yc=e=>{if(!e){t&&j.warn("Supabase integration was not installed because no Supabase client was provided.");return}const n=e.constructor===Function?e:e.constructor;mc(n);hc(e)};const vc="Supabase";const bc=t=>({setupOnce(){yc(t)},name:vc});const Sc=io((t=>bc(t.supabaseClient)));const Ec=10;const wc="ZodErrors";function xc(t){return a(t)&&t.name==="ZodError"&&Array.isArray(t.issues)}function kc(t){return{...t,path:"path"in t&&Array.isArray(t.path)?t.path.join("."):void 0,keys:"keys"in t?JSON.stringify(t.keys):void 0,unionErrors:"unionErrors"in t?JSON.stringify(t.unionErrors):void 0}}
/**
 * Takes ZodError issue path array and returns a flattened version as a string.
 * This makes it easier to display paths within a Sentry error message.
 *
 * Array indexes are normalized to reduce duplicate entries
 *
 * @param path ZodError issue path
 * @returns flattened path
 *
 * @example
 * flattenIssuePath([0, 'foo', 1, 'bar']) // -> '<array>.foo.<array>.bar'
 */function Ic(t){return t.map((t=>typeof t==="number"?"<array>":t)).join(".")}function $c(t){const e=new Set;for(const n of t.issues){const t=Ic(n.path);t.length>0&&e.add(t)}const n=Array.from(e);if(n.length===0){let e="variable";if(t.issues.length>0){const n=t.issues[0];n!==void 0&&"expected"in n&&typeof n.expected==="string"&&(e=n.expected)}return`Failed to validate ${e}`}return`Failed to validate keys: ${M(n.join(", "),100)}`}function Tc(t,e=false,n,r){if(!n.exception?.values||!r.originalException||!xc(r.originalException)||r.originalException.issues.length===0)return n;try{const s=e?r.originalException.issues:r.originalException.issues.slice(0,t);const o=s.map(kc);if(e){Array.isArray(r.attachments)||(r.attachments=[]);r.attachments.push({filename:"zod_issues.json",data:JSON.stringify({issues:o})})}return{...n,exception:{...n.exception,values:[{...n.exception.values[0],value:$c(r.originalException)},...n.exception.values.slice(1)]},extra:{...n.extra,"zoderror.issues":o.slice(0,t)}}}catch(t){return{...n,extra:{...n.extra,"zoderrors sentry integration parse error":{message:"an exception was thrown while processing ZodError within applyZodErrorsToEvent()",error:t instanceof Error?`${t.name}: ${t.message}\n${t.stack}`:"unknown"}}}}}const Ac=(t={})=>{const e=t.limit??Ec;return{name:wc,processEvent(n,r){const s=Tc(e,t.saveZodIssuesAsAttachment,n,r);return s}}};const Oc=io(Ac);const Cc=io((t=>({name:"ThirdPartyErrorsFilter",setup(t){t.on("beforeEnvelope",(t=>{ir(t,((t,e)=>{if(e==="event"){const e=Array.isArray(t)?t[1]:void 0;if(e){pa(e);t[1]=e}}}))}));t.on("applyFrameMetadata",(e=>{if(e.type)return;const n=t.getOptions().stackParser;la(n,e)}))},processEvent(e){const n=Pc(e);if(n){const r=t.behaviour==="drop-error-if-contains-third-party-frames"||t.behaviour==="apply-tag-if-contains-third-party-frames"?"some":"every";const s=n[r]((e=>!e.some((e=>t.filterKeys.includes(e)))));if(s){const n=t.behaviour==="drop-error-if-contains-third-party-frames"||t.behaviour==="drop-error-if-exclusively-contains-third-party-frames";if(n)return null;e.tags={...e.tags,third_party_code:true}}}return e}})));function Pc(t){const e=fn(t);if(e)return e.filter((t=>!!t.filename)).map((t=>t.module_metadata?Object.keys(t.module_metadata).filter((t=>t.startsWith(Nc))).map((t=>t.slice(Nc.length))):[]))}const Nc="_sentryBundlerPluginAppKey:";const Rc="Console";const Dc=io(((t={})=>{const e=new Set(t.levels||P);return{name:Rc,setup(t){xa((({args:n,level:r})=>{Wt()===t&&e.has(r)&&jc(r,n)}))}}}));function jc(t,e){const n={category:"console",data:{arguments:e,logger:"console"},level:Ia(t),message:Mc(e)};if(t==="assert"){if(e[0]!==false)return;{const t=e.slice(1);n.message=t.length>0?`Assertion failed: ${Mc(t)}`:"Assertion failed";n.data.arguments=t}}Pi(n,{input:e,level:t})}function Mc(t){return"util"in n&&typeof n.util.format==="function"?n.util.format(...t):F(t," ")}function Lc(t){return!!t&&typeof t._profiler!=="undefined"&&typeof t._profiler.start==="function"&&typeof t._profiler.stop==="function"}function Fc(){const e=Wt();if(!e){t&&j.warn("No Sentry client available, profiling is not started");return}const n=e.getIntegrationByName("ProfilingIntegration");n?Lc(n)?n._profiler.start():t&&j.warn("Profiler is not available on profiling integration."):t&&j.warn("ProfilingIntegration is not available")}function Uc(){const e=Wt();if(!e){t&&j.warn("No Sentry client available, profiling is not started");return}const n=e.getIntegrationByName("ProfilingIntegration");n?Lc(n)?n._profiler.stop():t&&j.warn("Profiler is not available on profiling integration."):t&&j.warn("ProfilingIntegration is not available")}const zc={startProfiler:Fc,stopProfiler:Uc};const qc="thismessage:/";
/**
 * Checks if the URL object is relative
 *
 * @param url - The URL object to check
 * @returns True if the URL object is relative, false otherwise
 */function Bc(t){return"isRelative"in t}
/**
 * Parses string to a URL object
 *
 * @param url - The URL to parse
 * @returns The parsed URL object or undefined if the URL is invalid
 */function Wc(t,e){const n=t.startsWith("/");const r=e??(n?qc:void 0);try{if("canParse"in URL&&!URL.canParse(t,r))return;const e=new URL(t,r);return n?{isRelative:n,pathname:e.pathname,search:e.search,hash:e.hash}:e}catch{}}function Jc(t){if(Bc(t))return t.pathname;const e=new URL(t);e.search="";e.hash="";["80","443"].includes(e.port)&&(e.port="");e.password&&(e.password="%filtered%");e.username&&(e.username="%filtered%");return e.toString()}
/**
 * Parses string form of URL into an object
 * // borrowed from https://tools.ietf.org/html/rfc3986#appendix-B
 * // intentionally using regex and not <a/> href parsing trick because React Native and other
 * // environments where DOM might not be available
 * @returns parsed URL object
 */function Gc(t){if(!t)return{};const e=t.match(/^(([^:/?#]+):)?(\/\/([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?$/);if(!e)return{};const n=e[6]||"";const r=e[8]||"";return{host:e[4],path:e[5],protocol:e[2],search:n,hash:r,relative:e[5]+n+r}}
/**
 * Strip the query string and fragment off of a given URL or path (if present)
 *
 * @param urlPath Full URL or path, including possible query string and/or fragment
 * @returns URL or path without query string or fragment
 */function Zc(t){return t.split(/[?#]/,1)[0]}function Hc(t){const{protocol:e,host:n,path:r}=t;const s=n?.replace(/^.*@/,"[filtered]:[filtered]@").replace(/(:80)$/,"").replace(/(:443)$/,"")||"";return`${e?`${e}://`:""}${s}${r}`}
/**
 * Create and track fetch request spans for usage in combination with `addFetchInstrumentationHandler`.
 *
 * @returns Span if a span was created, otherwise void.
 */function Yc(t,e,n,r,s="auto.http.browser"){if(!t.fetchData)return;const{method:o,url:i}=t.fetchData;const a=Tn()&&e(i);if(t.endTimestamp&&a){const e=t.fetchData.__span;if(!e)return;const n=r[e];if(n){Vc(n,t);delete r[e]}return}const c=!!Xe();const u=a&&c?Nr(tu(i,o,s)):new SentryNonRecordingSpan;t.fetchData.__span=u.spanContext().spanId;r[u.spanContext().spanId]=u;if(n(t.fetchData.url)){const e=t.args[0];const n=t.args[1]||{};const r=Kc(e,n,Tn()&&c?u:void 0);if(r){t.args[1]=n;n.headers=r}}const l=Wt();if(l){const e={input:t.args,response:t.response,startTimestamp:t.startTimestamp,endTimestamp:t.endTimestamp};l.emit("beforeOutgoingRequestSpan",u,e)}return u}function Kc(t,e,n){const r=Ei({span:n});const s=r["sentry-trace"];const o=r.baggage;if(!s)return;const i=e.headers||(w(t)?t.headers:void 0);if(i){if(Qc(i)){const t=new Headers(i);t.get("sentry-trace")||t.set("sentry-trace",s);if(o){const e=t.get("baggage");e?Xc(e)||t.set("baggage",`${e},${o}`):t.set("baggage",o)}return t}if(Array.isArray(i)){const t=[...i];i.find((t=>t[0]==="sentry-trace"))||t.push(["sentry-trace",s]);const e=i.find((t=>t[0]==="baggage"&&Xc(t[1])));o&&!e&&t.push(["baggage",o]);return t}{const t="sentry-trace"in i?i["sentry-trace"]:void 0;const e="baggage"in i?i.baggage:void 0;const n=e?Array.isArray(e)?[...e]:[e]:[];const r=e&&(Array.isArray(e)?e.find((t=>Xc(t))):Xc(e));o&&!r&&n.push(o);return{...i,"sentry-trace":t??s,baggage:n.length>0?n.join(","):void 0}}}return{...r}}function Vc(t,e){if(e.response){de(t,e.response.status);const n=e.response?.headers&&e.response.headers.get("content-length");if(n){const e=parseInt(n);e>0&&t.setAttribute("http.response_content_length",e)}}else e.error&&t.setStatus({code:pe,message:"internal_error"});t.end()}function Xc(t){return t.split(",").some((t=>t.trim().startsWith(ve)))}function Qc(t){return typeof Headers!=="undefined"&&S(t,Headers)}function tu(t,e,n){const r=Wc(t);return{name:r?`${e} ${Jc(r)}`:e,attributes:eu(t,r,e,n)}}function eu(t,e,n,r){const s={url:t,type:"fetch","http.method":n,[Kt]:r,[Yt]:"http.client"};if(e){if(!Bc(e)){s["http.url"]=e.href;s["server.address"]=e.host}e.search&&(s["http.query"]=e.search);e.hash&&(s["http.fragment"]=e.hash)}return s}const nu={mechanism:{handled:false,data:{function:"trpcMiddleware"}}};function ru(t){typeof t==="object"&&t!==null&&"ok"in t&&!t.ok&&"error"in t&&Is(t.error,nu)}function su(t={}){return async function(e){const{path:n,type:r,next:s,rawInput:o,getRawInput:i}=e;const a=Wt();const c=a?.getOptions();const u={procedure_path:n,procedure_type:r};B(u,"__sentry_override_normalization_depth__",1+(c?.normalizeDepth??5));if(t.attachRpcInput!==void 0?t.attachRpcInput:c?.sendDefaultPii){o!==void 0&&(u.input=Yn(o));if(i!==void 0&&typeof i==="function")try{const t=await i();u.input=Yn(t)}catch(t){}}return qt((e=>{e.setContext("trpc",u);return Pr({name:`trpc/${n}`,op:"rpc.server",attributes:{[Gt]:"route",[Kt]:"auto.rpc.trpc"},forceTransaction:!!t.forceTransaction},(async t=>{try{const e=await s();ru(e);t.end();return e}catch(e){Is(e,nu);t.end();throw e}}))}))}}const ou=new WeakSet;function iu(e){if(ou.has(e))return e;if(!au(e)){t&&j.warn("Did not patch MCP server. Interface is incompatible.");return e}e.connect=new Proxy(e.connect,{apply(t,e,n){const[r,...s]=n;r.onclose||(r.onclose=()=>{r.sessionId&&pu(r.sessionId)});r.onmessage||(r.onmessage=t=>{r.sessionId&&cu(t)&&fu(r.sessionId,t.id)});const o=new Proxy(r,{set(t,e,n){t[e]=e==="onmessage"?new Proxy(n,{apply(t,e,n){const[s]=n;r.sessionId&&cu(s)&&fu(r.sessionId,s.id);return Reflect.apply(t,e,n)}}):e==="onclose"?new Proxy(n,{apply(t,e,n){r.sessionId&&pu(r.sessionId);return Reflect.apply(t,e,n)}}):n;return true}});return Reflect.apply(t,e,[o,...s])}});e.resource=new Proxy(e.resource,{apply(t,e,n){const r=n[0];const s=n[n.length-1];if(typeof r!=="string"||typeof s!=="function")return t.apply(e,n);const o=new Proxy(s,{apply(t,e,n){const s=n.find(uu);return du(s,(()=>Cr({name:`mcp-server/resource:${r}`,forceTransaction:true,attributes:{[Yt]:"auto.function.mcp-server",[Kt]:"auto.function.mcp-server",[Gt]:"route","mcp_server.resource":r}},(()=>t.apply(e,n)))))}});return Reflect.apply(t,e,[...n.slice(0,-1),o])}});e.tool=new Proxy(e.tool,{apply(t,e,n){const r=n[0];const s=n[n.length-1];if(typeof r!=="string"||typeof s!=="function")return t.apply(e,n);const o=new Proxy(s,{apply(t,e,n){const s=n.find(uu);return du(s,(()=>Cr({name:`mcp-server/tool:${r}`,forceTransaction:true,attributes:{[Yt]:"auto.function.mcp-server",[Kt]:"auto.function.mcp-server",[Gt]:"route","mcp_server.tool":r}},(()=>t.apply(e,n)))))}});return Reflect.apply(t,e,[...n.slice(0,-1),o])}});e.prompt=new Proxy(e.prompt,{apply(t,e,n){const r=n[0];const s=n[n.length-1];if(typeof r!=="string"||typeof s!=="function")return t.apply(e,n);const o=new Proxy(s,{apply(t,e,n){const s=n.find(uu);return du(s,(()=>Cr({name:`mcp-server/prompt:${r}`,forceTransaction:true,attributes:{[Yt]:"auto.function.mcp-server",[Kt]:"auto.function.mcp-server",[Gt]:"route","mcp_server.prompt":r}},(()=>t.apply(e,n)))))}});return Reflect.apply(t,e,[...n.slice(0,-1),o])}});ou.add(e);return e}function au(t){return typeof t==="object"&&t!==null&&"resource"in t&&typeof t.resource==="function"&&"tool"in t&&typeof t.tool==="function"&&"prompt"in t&&typeof t.prompt==="function"&&"connect"in t&&typeof t.connect==="function"}function cu(t){return typeof t==="object"&&t!==null&&"id"in t&&(typeof t.id==="number"||typeof t.id==="string")}function uu(t){return typeof t==="object"&&t!==null&&"sessionId"in t&&typeof t.sessionId==="string"&&"requestId"in t&&(typeof t.requestId==="number"||typeof t.requestId==="string")}const lu=new Map;function pu(t){lu.delete(t)}function fu(t,e){const n=Xe();if(n){const r=lu.get(t)??new Map;r.set(e,n);lu.set(t,r)}}function du(t,e){if(t){const{sessionId:n,requestId:r}=t;const s=lu.get(n);if(!s)return e();const o=s.get(r);if(!o)return e();s.delete(r);return Dr(o,(()=>e()))}return e()}function hu(t,e={},n=Ft()){const{message:r,name:s,email:o,url:i,source:a,associatedEventId:c,tags:u}=t;const l={contexts:{feedback:{contact_email:o,name:s,message:r,url:i,source:a,associated_event_id:c}},type:"feedback",level:"info",tags:u};const p=n?.getClient()||Wt();p&&p.emit("beforeSendFeedback",l,e);const f=n.captureEvent(l,e);return f}const mu="ConsoleLogs";const gu={[Kt]:"auto.console.logging"};const _u=(e={})=>{const n=e.levels||P;return{name:mu,setup(e){e.getOptions()._experiments?.enableLogs?xa((({args:t,level:r})=>{if(Wt()!==e||!n.includes(r))return;if(r==="assert"){if(!t[0]){const e=t.slice(1);const n=e.length>0?`Assertion failed: ${vu(e)}`:"Assertion failed";No({level:"error",message:n,attributes:gu})}return}const s=r==="log";No({level:s?"info":r,message:vu(t),severityNumber:s?10:void 0,attributes:gu})})):t&&j.warn("`_experiments.enableLogs` is not enabled, ConsoleLogs integration disabled")}}};const yu=io(_u);function vu(t){return"util"in n&&typeof n.util.format==="function"?n.util.format(...t):F(t," ")}function bu(t){return t===void 0?void 0:t>=400&&t<500?"warning":t>=500?"error":void 0}
/**
 * An error emitted by Sentry SDKs and related utilities.
 * @deprecated This class is no longer used and will be removed in a future version. Use `Error` instead.
 */class SentryError extends Error{constructor(t,e="warn"){super(t);this.message=t;this.logLevel=e}}const Su=n;
/**
 * Tells whether current environment supports ErrorEvent objects
 * {@link supportsErrorEvent}.
 *
 * @returns Answer to the given question.
 */function Eu(){try{new ErrorEvent("");return true}catch(t){return false}}
/**
 * Tells whether current environment supports DOMError objects
 * {@link supportsDOMError}.
 *
 * @returns Answer to the given question.
 */function wu(){try{new DOMError("");return true}catch(t){return false}}
/**
 * Tells whether current environment supports DOMException objects
 * {@link supportsDOMException}.
 *
 * @returns Answer to the given question.
 */function xu(){try{new DOMException("");return true}catch(t){return false}}
/**
 * Tells whether current environment supports History API
 * {@link supportsHistory}.
 *
 * @returns Answer to the given question.
 */function ku(){return"history"in Su&&!!Su.history}
/**
 * Tells whether current environment supports Fetch API
 * {@link supportsFetch}.
 *
 * @returns Answer to the given question.
 */function Iu(){if(!("fetch"in Su))return false;try{new Headers;new Request("http://www.example.com");new Response;return true}catch(t){return false}}function $u(t){return t&&/^function\s+\w+\(\)\s+\{\s+\[native code\]\s+\}$/.test(t.toString())}
/**
 * Tells whether current environment supports Fetch API natively
 * {@link supportsNativeFetch}.
 *
 * @returns true if `window.fetch` is natively implemented, false otherwise
 */function Tu(){if(typeof EdgeRuntime==="string")return true;if(!Iu())return false;if($u(Su.fetch))return true;let t=false;const e=Su.document;if(e&&typeof e.createElement==="function")try{const n=e.createElement("iframe");n.hidden=true;e.head.appendChild(n);n.contentWindow?.fetch&&(t=$u(n.contentWindow.fetch));e.head.removeChild(n)}catch(t){O&&j.warn("Could not create sandbox iframe for pure fetch check, bailing to window.fetch: ",t)}return t}
/**
 * Tells whether current environment supports ReportingObserver API
 * {@link supportsReportingObserver}.
 *
 * @returns Answer to the given question.
 */function Au(){return"ReportingObserver"in Su}
/**
 * Tells whether current environment supports Referrer Policy API
 * {@link supportsReferrerPolicy}.
 *
 * @returns Answer to the given question.
 */function Ou(){if(!Iu())return false;try{new Request("_",{referrerPolicy:"origin"});return true}catch(t){return false}}function Cu(t,e){const n="fetch";mn(n,t);_n(n,(()=>Nu(void 0,e)))}function Pu(t){const e="fetch-body-resolved";mn(e,t);_n(e,(()=>Nu(Du)))}function Nu(t,e=false){e&&!Tu()||q(n,"fetch",(function(e){return function(...r){const s=new Error;const{method:o,url:i}=Lu(r);const c={args:r,fetchData:{method:o,url:i},startTimestamp:mt()*1e3,virtualError:s,headers:Fu(r)};t||yn("fetch",{...c});return e.apply(n,r).then((async e=>{t?t(e):yn("fetch",{...c,endTimestamp:mt()*1e3,response:e});return e}),(t=>{yn("fetch",{...c,endTimestamp:mt()*1e3,error:t});if(a(t)&&t.stack===void 0){t.stack=s.stack;B(t,"framesToPop",1)}if(t instanceof TypeError&&(t.message==="Failed to fetch"||t.message==="Load failed"||t.message==="NetworkError when attempting to fetch resource."))try{const e=new URL(c.fetchData.url);t.message=`${t.message} (${e.host})`}catch{}throw t}))}}))}async function Ru(t,e){if(t?.body){const n=t.body;const r=n.getReader();const s=setTimeout((()=>{n.cancel().then(null,(()=>{}))}),9e4);let o=true;while(o){let t;try{t=setTimeout((()=>{n.cancel().then(null,(()=>{}))}),5e3);const{done:s}=await r.read();clearTimeout(t);if(s){e();o=false}}catch(t){o=false}finally{clearTimeout(t)}}clearTimeout(s);r.releaseLock();n.cancel().then(null,(()=>{}))}}function Du(t){let e;try{e=t.clone()}catch{return}Ru(e,(()=>{yn("fetch-body-resolved",{endTimestamp:mt()*1e3,response:t})}))}function ju(t,e){return!!t&&typeof t==="object"&&!!t[e]}function Mu(t){return typeof t==="string"?t:t?ju(t,"url")?t.url:t.toString?t.toString():"":""}function Lu(t){if(t.length===0)return{method:"GET",url:""};if(t.length===2){const[e,n]=t;return{url:Mu(e),method:ju(n,"method")?String(n.method).toUpperCase():"GET"}}const e=t[0];return{url:Mu(e),method:ju(e,"method")?String(e.method).toUpperCase():"GET"}}function Fu(t){const[e,n]=t;try{if(typeof n==="object"&&n!==null&&"headers"in n&&n.headers)return new Headers(n.headers);if(w(e))return new Headers(e.headers)}catch{}}
/**
 * Figures out if we're building a browser bundle.
 *
 * @returns true if this is a browser bundle build.
 */function Uu(){return typeof __SENTRY_BROWSER_BUNDLE__!=="undefined"&&!!__SENTRY_BROWSER_BUNDLE__}function zu(){return"npm"}
/**
 * Checks whether we're in the Node.js or Browser environment
 *
 * @returns Answer to given question
 */function qu(){return!Uu()&&Object.prototype.toString.call(typeof process!=="undefined"?process:0)==="[object process]"}
/**
 * Requires a module which is protected against bundler minification.
 *
 * @param request The module path to resolve
 */function Bu(t,e){return t.require(e)}
/**
 * Helper for dynamically loading module that should work with linked dependencies.
 * The problem is that we _should_ be using `require(require.resolve(moduleName, { paths: [cwd()] }))`
 * However it's _not possible_ to do that with Webpack, as it has to know all the dependencies during
 * build time. `require.resolve` is also not available in any other way, so we cannot create,
 * a fake helper like we do with `dynamicRequire`.
 *
 * We always prefer to use local package, thus the value is not returned early from each `try/catch` block.
 * That is to mimic the behavior of `require.resolve` exactly.
 *
 * @param moduleName module name to require
 * @param existingModule module to use for requiring
 * @returns possibly required module
 */function Wu(t,e=module){let n;try{n=Bu(e,t)}catch(t){}if(!n)try{const{cwd:r}=Bu(e,"process");n=Bu(e,`${r()}/node_modules/${t}`)}catch(t){}return n}function Ju(){return typeof window!=="undefined"&&(!qu()||Gu())}function Gu(){const t=n.process;return t?.type==="renderer"}function Zu(t,e=false){const n=e||t&&!t.startsWith("/")&&!t.match(/^[A-Z]:/)&&!t.startsWith(".")&&!t.match(/^[a-zA-Z]([a-zA-Z0-9.\-+])*:\/\//);return!n&&t!==void 0&&!t.includes("node_modules/")}function Hu(t){const e=/^\s*[-]{4,}$/;const n=/at (?:async )?(?:(.+?)\s+\()?(?:(.+):(\d+):(\d+)?|([^)]+))\)?/;return r=>{const s=r.match(n);if(s){let e;let n;let r;let o;let i;if(s[1]){r=s[1];let t=r.lastIndexOf(".");r[t-1]==="."&&t--;if(t>0){e=r.slice(0,t);n=r.slice(t+1);const s=e.indexOf(".Module");if(s>0){r=r.slice(s+1);e=e.slice(0,s)}}o=void 0}if(n){o=e;i=n}if(n==="<anonymous>"){i=void 0;r=void 0}if(r===void 0){i=i||nn;r=o?`${o}.${i}`:i}let a=s[2]?.startsWith("file://")?s[2].slice(7):s[2];const c=s[5]==="native";a?.match(/\/[A-Z]:/)&&(a=a.slice(1));a||!s[5]||c||(a=s[5]);return{filename:a?decodeURI(a):void 0,module:t?t(a):void 0,function:r,lineno:Ku(s[3]),colno:Ku(s[4]),in_app:Zu(a||"",c)}}if(r.match(e))return{filename:r}}}function Yu(t){return[90,Hu(t)]}function Ku(t){return parseInt(t||"",10)||void 0}
/**
 * A node.js watchdog timer
 * @param pollInterval The interval that we expect to get polled at
 * @param anrThreshold The threshold for when we consider ANR
 * @param callback The callback to call for ANR
 * @returns An object with `poll` and `enabled` functions {@link WatchdogReturn}
 */function Vu(t,e,n,r){const s=t();let o=false;let i=true;setInterval((()=>{const t=s.getTimeMs();if(o===false&&t>e+n){o=true;i&&r()}t<e+n&&(o=false)}),20);return{poll:()=>{s.reset()},enabled:t=>{i=t}}}function Xu(t,e,n){const r=e?e.replace(/^file:\/\//,""):void 0;const s=t.location.columnNumber?t.location.columnNumber+1:void 0;const o=t.location.lineNumber?t.location.lineNumber+1:void 0;return{filename:r,module:n(r),function:t.functionName||nn,colno:s,lineno:o,in_app:r?Zu(r):void 0}}class LRUMap{constructor(t){this._maxSize=t;this._cache=new Map}get size(){return this._cache.size}get(t){const e=this._cache.get(t);if(e!==void 0){this._cache.delete(t);this._cache.set(t,e);return e}}set(t,e){this._cache.size>=this._maxSize&&this._cache.delete(this._cache.keys().next().value);this._cache.set(t,e)}remove(t){const e=this._cache.get(t);e&&this._cache.delete(t);return e}clear(){this._cache.clear()}keys(){return Array.from(this._cache.keys())}values(){const t=[];this._cache.forEach((e=>t.push(e)));return t}}function Qu(t){const e=n[Symbol.for("@vercel/request-context")];const r=e?.get&&e.get()?e.get():{};r?.waitUntil&&r.waitUntil(t)}
/**
 * Given a string, escape characters which have meaning in the regex grammar, such that the result is safe to feed to
 * `new RegExp()`.
 *
 * @param regexString The string to escape
 * @returns An version of the string with all special regex characters escaped
 */function tl(t){return t.replace(/[|\\{}()[\]^$+*?.]/g,"\\$&").replace(/-/g,"\\x2d")}export{bo as BaseClient,P as CONSOLE_LEVELS,Client,On as DEFAULT_ENVIRONMENT,Xo as DEFAULT_RETRY_AFTER,n as GLOBAL_OBJ,LRUMap,Se as MAX_BAGGAGE_STRING_LENGTH,e as SDK_VERSION,re as SEMANTIC_ATTRIBUTE_CACHE_HIT,oe as SEMANTIC_ATTRIBUTE_CACHE_ITEM_SIZE,se as SEMANTIC_ATTRIBUTE_CACHE_KEY,ne as SEMANTIC_ATTRIBUTE_EXCLUSIVE_TIME,ie as SEMANTIC_ATTRIBUTE_HTTP_REQUEST_METHOD,ee as SEMANTIC_ATTRIBUTE_PROFILE_ID,te as SEMANTIC_ATTRIBUTE_SENTRY_CUSTOM_SPAN_NAME,Vt as SEMANTIC_ATTRIBUTE_SENTRY_IDLE_SPAN_FINISH_REASON,Xt as SEMANTIC_ATTRIBUTE_SENTRY_MEASUREMENT_UNIT,Qt as SEMANTIC_ATTRIBUTE_SENTRY_MEASUREMENT_VALUE,Yt as SEMANTIC_ATTRIBUTE_SENTRY_OP,Kt as SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN,Ht as SEMANTIC_ATTRIBUTE_SENTRY_PREVIOUS_TRACE_SAMPLE_RATE,Zt as SEMANTIC_ATTRIBUTE_SENTRY_SAMPLE_RATE,Gt as SEMANTIC_ATTRIBUTE_SENTRY_SOURCE,ae as SEMANTIC_ATTRIBUTE_URL_FULL,ce as SEMANTIC_LINK_ATTRIBUTE_LINK_TYPE,ve as SENTRY_BAGGAGE_KEY_PREFIX,be as SENTRY_BAGGAGE_KEY_PREFIX_REGEX,Ko as SENTRY_BUFFER_FULL_ERROR,pe as SPAN_STATUS_ERROR,le as SPAN_STATUS_OK,ue as SPAN_STATUS_UNSET,Scope,SentryError,SentryNonRecordingSpan,SentrySpan,ServerRuntimeClient,SyncPromise,$e as TRACEPARENT_REGEXP,Jr as TRACING_DEFAULTS,nn as UNKNOWN_FUNCTION,No as _INTERNAL_captureLog,Ro as _INTERNAL_flushLogsBuffer,bi as addAutoIpAddressToSession,vi as addAutoIpAddressToUser,Pi as addBreadcrumb,He as addChildSpanToSpan,xa as addConsoleInstrumentationHandler,ut as addContextToFrame,qs as addEventProcessor,ot as addExceptionMechanism,st as addExceptionTypeValue,Pu as addFetchEndInstrumentationHandler,Cu as addFetchInstrumentationHandler,bn as addGlobalErrorInstrumentationHandler,wn as addGlobalUnhandledRejectionInstrumentationHandler,mn as addHandler,oo as addIntegration,or as addItemToEnvelope,B as addNonEnumerableProperty,Vi as applyAggregateErrorsToEvent,as as applyScopeDataToEvent,Si as applySdkMetadata,Ee as baggageHeaderToDynamicSamplingContext,ec as basename,yt as browserPerformanceTimeOrigin,Xu as callFrameToStackFrame,js as captureCheckIn,Aa as captureConsoleIntegration,Ts as captureEvent,Is as captureException,hu as captureFeedback,$s as captureMessage,Gs as captureSession,lt as checkOrSetAlreadyCaught,Fs as close,St as closeSession,Dc as consoleIntegration,yu as consoleLoggingIntegration,R as consoleSandbox,Rr as continueTrace,Le as convertSpanLinksForEnvelope,G as convertToPlainObject,hr as createAttachmentEnvelopeItem,Io as createCheckInEnvelope,lo as createClientReportEnvelope,sr as createEnvelope,Sr as createEventEnvelope,yr as createEventEnvelopeHeaders,br as createSessionEnvelope,Er as createSpanEnvelope,dr as createSpanEnvelopeItem,on as createStackParser,si as createTransport,dt as dateTimestampInSeconds,Na as dedupeIntegration,io as defineIntegration,tc as dirname,ti as disabledUntil,K as dropUndefinedKeys,Jn as dsnFromString,Wn as dsnToString,we as dynamicSamplingContextToSentryBaggageHeader,Ws as endSession,ar as envelopeContainsItemType,gr as envelopeItemTypeToDataCategory,tl as escapeStringForRegex,Ui as eventFiltersIntegration,Bo as eventFromMessage,qo as eventFromUnknownInput,Mo as exceptionFromError,qa as extraErrorDataIntegration,Y as extractExceptionKeysForMessage,Oi as extractQueryParamsFromUrl,Te as extractTraceparentData,Zu as filenameIsInApp,q as fill,Ls as flush,yi as fmt,ir as forEachEnvelopeItem,Mi as functionToStringIntegration,Oe as generateSentryTraceHeader,Tt as generateSpanId,$t as generateTraceId,Xe as getActiveSpan,bu as getBreadcrumbLogLevelFromHttpStatusCode,_e as getCapturedScopesOnSpan,Wt as getClient,A as getComponentName,Ft as getCurrentScope,is as getDebugImagesForResources,Ot as getDefaultCurrentScope,Ct as getDefaultIsolationScope,Nn as getDynamicSamplingContextFromClient,Rn as getDynamicSamplingContextFromScope,Dn as getDynamicSamplingContextFromSpan,Vs as getEnvelopeEndpointWithUrlEncodedAuth,rt as getEventDescription,os as getFilenameToDebugIdMap,fn as getFramesFromEvent,pn as getFunctionName,zt as getGlobalScope,o as getGlobalSingleton,eo as getIntegrationsToSetup,Ut as getIsolationScope,T as getLocationHref,r as getMainCarrier,J as getOriginalFunction,Xs as getReportDialogEndpoint,Ve as getRootSpan,zu as getSDKSource,Hc as getSanitizedUrlString,Jc as getSanitizedUrlStringFromUrlObject,_r as getSdkMetadataForEnvelopeHeader,Ke as getSpanDescendants,fe as getSpanStatusFromHttpCode,Je as getStatusMessage,Jt as getTraceContextFromScope,Ei as getTraceData,xi as getTraceMetaTags,Mn as handleCallbackErrors,Tn as hasSpansEnabled,An as hasTracingEnabled,Ii as headersToDict,I as htmlTreeAsString,Ti as httpRequestToRequestData,zi as inboundFiltersIntegration,Ho as initAndBind,Yc as instrumentFetchRequest,yc as instrumentSupabaseClient,Xa as isAbsolute,Ju as isBrowser,Uu as isBrowserBundle,l as isDOMError,p as isDOMException,_ as isElement,zs as isEnabled,a as isError,u as isErrorEvent,g as isEvent,Us as isInitialized,S as isInstanceOf,U as isMatchingPattern,$u as isNativeFunction,qu as isNodeEnv,d as isParameterizedString,m as isPlainObject,h as isPrimitive,ei as isRateLimited,y as isRegExp,di as isSentryRequestUrl,f as isString,b as isSyntheticEvent,v as isThenable,Bc as isURLObjectRelative,E as isVueViewModel,Qa as join,Ds as lastEventId,oa as linkedErrorsIntegration,Wu as loadModule,Un as logSpanEnd,Fn as logSpanStart,j as logger,Hn as makeDsn,fi as makeMultiplexedTransport,ci as makeOfflineTransport,Vo as makePromiseBuffer,vt as makeSession,W as markFunctionWrapped,_n as maybeInstrument,cs as mergeScopeData,fa as moduleMetadataIntegration,Hu as node,Yu as nodeStackLineParser,Yn as normalize,Va as normalizePath,Kn as normalizeToSize,nr as normalizeUrlToBase,es as notifyEventProcessors,Ie as objectToBaggageHeader,Q as objectify,N as originalConsoleMethods,_i as parameterize,xe as parseBaggageHeader,fr as parseEnvelope,Qo as parseRetryAfterHeader,ye as parseSampleRate,ct as parseSemver,jo as parseStackFrames,Wc as parseStringToURLObject,Gc as parseUrl,ms as prepareEvent,zc as profiler,Ae as propagationContextFromHeaders,In as registerSpanErrorInstrumentation,ts as rejectedSyncPromise,Ka as relative,Sa as requestDataIntegration,gn as resetInstrumentationHandlers,Ha as resolve,Qr as resolvedSyncPromise,rc as rewriteFramesIntegration,F as safeJoin,zn as sampleSpan,lr as serializeEnvelope,Mt as setAsyncContextStrategy,ge as setCapturedScopesOnSpan,As as setContext,Yo as setCurrentClient,Cs as setExtra,Os as setExtras,de as setHttpStatus,wr as setMeasurement,Ns as setTag,Ps as setTags,Rs as setUser,Ia as severityLevelFromString,L as snipLine,We as spanIsSampled,Fe as spanTimeInputToSeconds,jn as spanToBaggageHeader,ze as spanToJSON,je as spanToTraceContext,Me as spanToTraceHeader,an as stackParserFromStackParserOptions,Kr as startIdleSpan,Nr as startInactiveSpan,Mr as startNewTrace,Bs as startSession,Cr as startSpan,Pr as startSpanManual,z as stringMatchesSomePattern,cn as stripSentryFramesAndReverse,Zc as stripUrlQueryAndFragment,Sc as supabaseIntegration,wu as supportsDOMError,xu as supportsDOMException,Eu as supportsErrorEvent,Iu as supportsFetch,ku as supportsHistory,Tu as supportsNativeFetch,Ou as supportsReferrerPolicy,Au as supportsReportingObserver,jr as suppressTracing,Cc as thirdPartyErrorFilterIntegration,xr as timedEventsToMeasurements,mt as timestampInSeconds,yn as triggerHandlers,su as trpcMiddleware,M as truncate,ni as updateRateLimits,bt as updateSession,tn as updateSpanName,et as uuid4,Qu as vercelWaitUntil,Vu as watchdogTimer,ki as winterCGHeadersToDict,$i as winterCGRequestToRequestData,Dr as withActiveSpan,Bt as withIsolationScope,Ms as withMonitor,qt as withScope,iu as wrapMcpServerWithSentry,Oc as zodErrorsIntegration};

