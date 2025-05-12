// @sentry/browser@9.17.0 downloaded from https://ga.jspm.io/npm:@sentry/browser@9.17.0/build/npm/esm/index.js

import{buildFeedbackIntegration as t,feedbackScreenshotIntegration as e,feedbackModalIntegration as n}from"@sentry-internal/feedback";export{getFeedback,sendFeedback}from"@sentry-internal/feedback";import{GLOBAL_OBJ as r,getOriginalFunction as o,withScope as s,addExceptionTypeValue as a,addExceptionMechanism as i,captureException as c,markFunctionWrapped as u,addNonEnumerableProperty as l,getClient as f,SDK_VERSION as p,_INTERNAL_captureLog as d,fmt as m,normalizeToSize as g,isEvent as h,resolvedSyncPromise as y,isErrorEvent as v,isDOMError as _,isDOMException as b,isError as S,isPlainObject as x,isParameterizedString as T,extractExceptionKeysForMessage as E,Client as w,getSDKSource as k,applySdkMetadata as I,_INTERNAL_flushLogsBuffer as P,addAutoIpAddressToUser as R,addAutoIpAddressToSession as C,rejectedSyncPromise as O,createTransport as q,UNKNOWN_FUNCTION as L,createStackParser as $,dsnToString as A,createEnvelope as D,addConsoleInstrumentationHandler as F,addFetchInstrumentationHandler as N,defineIntegration as H,addBreadcrumb as M,getEventDescription as j,logger as B,htmlTreeAsString as U,getComponentName as z,safeJoin as W,severityLevelFromString as X,getBreadcrumbLogLevelFromHttpStatusCode as G,parseUrl as Y,fill as V,getFunctionName as K,startSession as J,captureSession as Q,addGlobalErrorInstrumentationHandler as Z,captureEvent as tt,addGlobalUnhandledRejectionInstrumentationHandler as et,isPrimitive as nt,isString as rt,getLocationHref as ot,applyAggregateErrorsToEvent as st,inboundFiltersIntegration as at,functionToStringIntegration as it,dedupeIntegration as ct,consoleSandbox as ut,supportsFetch as lt,getIntegrationsToSetup as ft,stackParserFromStackParserOptions as pt,initAndBind as dt,getCurrentScope as mt,lastEventId as gt,getReportDialogEndpoint as ht,captureMessage as yt,supportsReportingObserver as vt,supportsNativeFetch as _t,isSentryRequestUrl as bt,stripUrlQueryAndFragment as St,addContextToFrame as xt,spanToJSON as Tt,SEMANTIC_ATTRIBUTE_SENTRY_OP as Et,SEMANTIC_ATTRIBUTE_URL_FULL as wt,SEMANTIC_ATTRIBUTE_HTTP_REQUEST_METHOD as kt,stringMatchesSomePattern as It,addFetchEndInstrumentationHandler as Pt,instrumentFetchRequest as Rt,browserPerformanceTimeOrigin as Ct,hasSpansEnabled as Ot,setHttpStatus as qt,getActiveSpan as Lt,startInactiveSpan as $t,SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN as At,SentryNonRecordingSpan as Dt,getTraceData as Ft,getRootSpan as Nt,SPAN_STATUS_ERROR as Ht,SEMANTIC_ATTRIBUTE_SENTRY_PREVIOUS_TRACE_SAMPLE_RATE as Mt,SEMANTIC_ATTRIBUTE_SENTRY_SAMPLE_RATE as jt,SEMANTIC_LINK_ATTRIBUTE_LINK_TYPE as Bt,TRACING_DEFAULTS as Ut,registerSpanErrorInstrumentation as zt,SEMANTIC_ATTRIBUTE_SENTRY_SOURCE as Wt,startIdleSpan as Xt,getDynamicSamplingContextFromSpan as Gt,spanIsSampled as Yt,getIsolationScope as Vt,generateTraceId as Kt,propagationContextFromHeaders as Jt,SEMANTIC_ATTRIBUTE_SENTRY_IDLE_SPAN_FINISH_REASON as Qt,parseEnvelope as Zt,serializeEnvelope as te,makeOfflineTransport as ee,timestampInSeconds as ne,uuid4 as re,DEFAULT_ENVIRONMENT as oe,forEachEnvelopeItem as se,getDebugImagesForResources as ae}from"@sentry/core";export{SDK_VERSION,SEMANTIC_ATTRIBUTE_SENTRY_OP,SEMANTIC_ATTRIBUTE_SENTRY_ORIGIN,SEMANTIC_ATTRIBUTE_SENTRY_SAMPLE_RATE,SEMANTIC_ATTRIBUTE_SENTRY_SOURCE,Scope,addBreadcrumb,addEventProcessor,addIntegration,captureConsoleIntegration,captureEvent,captureException,captureFeedback,captureMessage,captureSession,close,consoleLoggingIntegration,continueTrace,createTransport,dedupeIntegration,endSession,eventFiltersIntegration,extraErrorDataIntegration,flush,functionToStringIntegration,getActiveSpan,getClient,getCurrentScope,getGlobalScope,getIsolationScope,getRootSpan,getSpanDescendants,getSpanStatusFromHttpCode,inboundFiltersIntegration,instrumentSupabaseClient,isInitialized,lastEventId,makeMultiplexedTransport,moduleMetadataIntegration,parameterize,registerSpanErrorInstrumentation,rewriteFramesIntegration,setContext,setCurrentClient,setExtra,setExtras,setHttpStatus,setMeasurement,setTag,setTags,setUser,spanToBaggageHeader,spanToJSON,spanToTraceHeader,startInactiveSpan,startNewTrace,startSession,startSpan,startSpanManual,supabaseIntegration,suppressTracing,thirdPartyErrorFilterIntegration,updateSpanName,withActiveSpan,withIsolationScope,withScope,zodErrorsIntegration}from"@sentry/core";import{getNativeImplementation as ie,clearCachedImplementation as ce,addClickKeypressInstrumentationHandler as ue,addXhrInstrumentationHandler as le,addHistoryInstrumentationHandler as fe,SENTRY_XHR_DATA_KEY as pe,getBodyString as de,getFetchRequestArgBody as me,addPerformanceInstrumentationHandler as ge,extractNetworkProtocol as he,startTrackingWebVitals as ye,startTrackingINP as ve,startTrackingLongAnimationFrames as _e,startTrackingLongTasks as be,startTrackingInteractions as Se,addPerformanceEntries as xe,registerInpInteractionListener as Te}from"@sentry-internal/browser-utils";export{getReplay,replayIntegration}from"@sentry-internal/replay";export{replayCanvasIntegration}from"@sentry-internal/replay-canvas";const Ee=r;let we=0;function ke(){return we>0}function Ie(){we++;setTimeout((()=>{we--}))}
/**
 * Instruments the given function and sends an event to Sentry every time the
 * function throws an exception.
 *
 * @param fn A function to wrap. It is generally safe to pass an unbound function, because the returned wrapper always
 * has a correct `this` context.
 * @returns The wrapped function.
 * @hidden
 */function Pe(t,e={}){function n(t){return typeof t==="function"}if(!n(t))return t;try{const e=t.__sentry_wrapped__;if(e)return typeof e==="function"?e:t;if(o(t))return t}catch(e){return t}const r=function(...n){try{const r=n.map((t=>Pe(t,e)));return t.apply(this,r)}catch(t){Ie();s((r=>{r.addEventProcessor((t=>{if(e.mechanism){a(t,void 0,void 0);i(t,e.mechanism)}t.extra={...t.extra,arguments:n};return t}));c(t)}));throw t}};try{for(const e in t)Object.prototype.hasOwnProperty.call(t,e)&&(r[e]=t[e])}catch{}u(r,t);l(t,"__sentry_wrapped__",r);try{const e=Object.getOwnPropertyDescriptor(r,"name");e.configurable&&Object.defineProperty(r,"name",{get(){return t.name}})}catch{}return r}const Re={replayIntegration:"replay",replayCanvasIntegration:"replay-canvas",feedbackIntegration:"feedback",feedbackModalIntegration:"feedback-modal",feedbackScreenshotIntegration:"feedback-screenshot",captureConsoleIntegration:"captureconsole",contextLinesIntegration:"contextlines",linkedErrorsIntegration:"linkederrors",dedupeIntegration:"dedupe",extraErrorDataIntegration:"extraerrordata",graphqlClientIntegration:"graphqlclient",httpClientIntegration:"httpclient",reportingObserverIntegration:"reportingobserver",rewriteFramesIntegration:"rewriteframes",browserProfilingIntegration:"browserprofiling",moduleMetadataIntegration:"modulemetadata"};const Ce=Ee;async function Oe(t,e){const n=Re[t];const r=Ce.Sentry=Ce.Sentry||{};if(!n)throw new Error(`Cannot lazy load integration: ${t}`);const o=r[t];if(typeof o==="function"&&!("_isShim"in o))return o;const s=qe(n);const a=Ee.document.createElement("script");a.src=s;a.crossOrigin="anonymous";a.referrerPolicy="strict-origin";e&&a.setAttribute("nonce",e);const i=new Promise(((t,e)=>{a.addEventListener("load",(()=>t()));a.addEventListener("error",e)}));const c=Ee.document.currentScript;const u=Ee.document.body||Ee.document.head||c?.parentElement;if(!u)throw new Error(`Could not find parent element to insert lazy-loaded ${t} script`);u.appendChild(a);try{await i}catch{throw new Error(`Error when loading integration: ${t}`)}const l=r[t];if(typeof l!=="function")throw new Error(`Could not load integration: ${t}`);return l}function qe(t){const e=f();const n=e?.getOptions()?.cdnBaseUrl||"https://browser.sentry-cdn.com";return new URL(`/${p}/${t}.min.js`,n).toString()}const Le=t({lazyLoadIntegration:Oe});const $e=t({getModalIntegration:()=>n,getScreenshotIntegration:()=>e});
/**
 * Capture a log with the given level.
 *
 * @param level - The level of the log.
 * @param message - The message to log.
 * @param attributes - Arbitrary structured data that stores information about the log - e.g., userId: 100.
 * @param severityNumber - The severity number of the log.
 */function Ae(t,e,n,r){d({level:t,message:e,attributes:n,severityNumber:r})}
/**
 * @summary Capture a log with the `trace` level. Requires `_experiments.enableLogs` to be enabled.
 *
 * @param message - The message to log.
 * @param attributes - Arbitrary structured data that stores information about the log - e.g., { userId: 100, route: '/dashboard' }.
 *
 * @example
 *
 * ```
 * Sentry.logger.trace('User clicked submit button', {
 *   buttonId: 'submit-form',
 *   formId: 'user-profile',
 *   timestamp: Date.now()
 * });
 * ```
 *
 * @example With template strings
 *
 * ```
 * Sentry.logger.trace(Sentry.logger.fmt`User ${user} navigated to ${page}`, {
 *   userId: '123',
 *   sessionId: 'abc-xyz'
 * });
 * ```
 */function De(t,e){Ae("trace",t,e)}
/**
 * @summary Capture a log with the `debug` level. Requires `_experiments.enableLogs` to be enabled.
 *
 * @param message - The message to log.
 * @param attributes - Arbitrary structured data that stores information about the log - e.g., { component: 'Header', state: 'loading' }.
 *
 * @example
 *
 * ```
 * Sentry.logger.debug('Component mounted', {
 *   component: 'UserProfile',
 *   props: { userId: 123 },
 *   renderTime: 150
 * });
 * ```
 *
 * @example With template strings
 *
 * ```
 * Sentry.logger.debug(Sentry.logger.fmt`API request to ${endpoint} failed`, {
 *   statusCode: 404,
 *   requestId: 'req-123',
 *   duration: 250
 * });
 * ```
 */function Fe(t,e){Ae("debug",t,e)}
/**
 * @summary Capture a log with the `info` level. Requires `_experiments.enableLogs` to be enabled.
 *
 * @param message - The message to log.
 * @param attributes - Arbitrary structured data that stores information about the log - e.g., { feature: 'checkout', status: 'completed' }.
 *
 * @example
 *
 * ```
 * Sentry.logger.info('User completed checkout', {
 *   orderId: 'order-123',
 *   amount: 99.99,
 *   paymentMethod: 'credit_card'
 * });
 * ```
 *
 * @example With template strings
 *
 * ```
 * Sentry.logger.info(Sentry.logger.fmt`User ${user} updated profile picture`, {
 *   userId: 'user-123',
 *   imageSize: '2.5MB',
 *   timestamp: Date.now()
 * });
 * ```
 */function Ne(t,e){Ae("info",t,e)}
/**
 * @summary Capture a log with the `warn` level. Requires `_experiments.enableLogs` to be enabled.
 *
 * @param message - The message to log.
 * @param attributes - Arbitrary structured data that stores information about the log - e.g., { browser: 'Chrome', version: '91.0' }.
 *
 * @example
 *
 * ```
 * Sentry.logger.warn('Browser compatibility issue detected', {
 *   browser: 'Safari',
 *   version: '14.0',
 *   feature: 'WebRTC',
 *   fallback: 'enabled'
 * });
 * ```
 *
 * @example With template strings
 *
 * ```
 * Sentry.logger.warn(Sentry.logger.fmt`API endpoint ${endpoint} is deprecated`, {
 *   recommendedEndpoint: '/api/v2/users',
 *   sunsetDate: '2024-12-31',
 *   clientVersion: '1.2.3'
 * });
 * ```
 */function He(t,e){Ae("warn",t,e)}
/**
 * @summary Capture a log with the `error` level. Requires `_experiments.enableLogs` to be enabled.
 *
 * @param message - The message to log.
 * @param attributes - Arbitrary structured data that stores information about the log - e.g., { error: 'NetworkError', url: '/api/data' }.
 *
 * @example
 *
 * ```
 * Sentry.logger.error('Failed to load user data', {
 *   error: 'NetworkError',
 *   url: '/api/users/123',
 *   statusCode: 500,
 *   retryCount: 3
 * });
 * ```
 *
 * @example With template strings
 *
 * ```
 * Sentry.logger.error(Sentry.logger.fmt`Payment processing failed for order ${orderId}`, {
 *   error: 'InsufficientFunds',
 *   amount: 100.00,
 *   currency: 'USD',
 *   userId: 'user-456'
 * });
 * ```
 */function Me(t,e){Ae("error",t,e)}
/**
 * @summary Capture a log with the `fatal` level. Requires `_experiments.enableLogs` to be enabled.
 *
 * @param message - The message to log.
 * @param attributes - Arbitrary structured data that stores information about the log - e.g., { appState: 'corrupted', sessionId: 'abc-123' }.
 *
 * @example
 *
 * ```
 * Sentry.logger.fatal('Application state corrupted', {
 *   lastKnownState: 'authenticated',
 *   sessionId: 'session-123',
 *   timestamp: Date.now(),
 *   recoveryAttempted: true
 * });
 * ```
 *
 * @example With template strings
 *
 * ```
 * Sentry.logger.fatal(Sentry.logger.fmt`Critical system failure in ${service}`, {
 *   service: 'payment-processor',
 *   errorCode: 'CRITICAL_FAILURE',
 *   affectedUsers: 150,
 *   timestamp: Date.now()
 * });
 * ```
 */function je(t,e){Ae("fatal",t,e)}var Be=Object.freeze(Object.defineProperty({__proto__:null,debug:Fe,error:Me,fatal:je,fmt:m,info:Ne,trace:De,warn:He},Symbol.toStringTag,{value:"Module"}));function Ue(t,e){const n=Xe(t,e);const r={type:Je(e),value:Qe(e)};n.length&&(r.stacktrace={frames:n});r.type===void 0&&r.value===""&&(r.value="Unrecoverable error caught");return r}function ze(t,e,n,r){const o=f();const s=o?.getOptions().normalizeDepth;const a=sn(e);const i={__serialized__:g(e,s)};if(a)return{exception:{values:[Ue(t,a)]},extra:i};const c={exception:{values:[{type:h(e)?e.constructor.name:r?"UnhandledRejection":"Error",value:rn(e,{isUnhandledRejection:r})}]},extra:i};if(n){const e=Xe(t,n);e.length&&(c.exception.values[0].stacktrace={frames:e})}return c}function We(t,e){return{exception:{values:[Ue(t,e)]}}}function Xe(t,e){const n=e.stacktrace||e.stack||"";const r=Ye(e);const o=Ve(e);try{return t(n,r,o)}catch(t){}return[]}const Ge=/Minified React error #\d+;/i;function Ye(t){return t&&Ge.test(t.message)?1:0}function Ve(t){return typeof t.framesToPop==="number"?t.framesToPop:0}function Ke(t){return typeof WebAssembly!=="undefined"&&typeof WebAssembly.Exception!=="undefined"&&t instanceof WebAssembly.Exception}function Je(t){const e=t?.name;if(!e&&Ke(t)){const e=t.message&&Array.isArray(t.message)&&t.message.length==2;return e?t.message[0]:"WebAssembly.Exception"}return e}function Qe(t){const e=t?.message;return Ke(t)?Array.isArray(t.message)&&t.message.length==2?t.message[1]:"wasm exception":e?e.error&&typeof e.error.message==="string"?e.error.message:e:"No error message"}function Ze(t,e,n,r){const o=n?.syntheticException||void 0;const s=en(t,e,o,r);i(s);s.level="error";n?.event_id&&(s.event_id=n.event_id);return y(s)}function tn(t,e,n="info",r,o){const s=r?.syntheticException||void 0;const a=nn(t,e,s,o);a.level=n;r?.event_id&&(a.event_id=r.event_id);return y(a)}function en(t,e,n,r,o){let s;if(v(e)&&e.error){const n=e;return We(t,n.error)}if(_(e)||b(e)){const o=e;if("stack"in e)s=We(t,e);else{const e=o.name||(_(o)?"DOMError":"DOMException");const i=o.message?`${e}: ${o.message}`:e;s=nn(t,i,n,r);a(s,i)}"code"in o&&(s.tags={...s.tags,"DOMException.code":`${o.code}`});return s}if(S(e))return We(t,e);if(x(e)||h(e)){const r=e;s=ze(t,r,n,o);i(s,{synthetic:true});return s}s=nn(t,e,n,r);a(s,`${e}`,void 0);i(s,{synthetic:true});return s}function nn(t,e,n,r){const o={};if(r&&n){const r=Xe(t,n);r.length&&(o.exception={values:[{value:e,stacktrace:{frames:r}}]});i(o,{synthetic:true})}if(T(e)){const{__sentry_template_string__:t,__sentry_template_values__:n}=e;o.logentry={message:t,params:n};return o}o.message=e;return o}function rn(t,{isUnhandledRejection:e}){const n=E(t);const r=e?"promise rejection":"exception";if(v(t))return`Event \`ErrorEvent\` captured as ${r} with message \`${t.message}\``;if(h(t)){const e=on(t);return`Event \`${e}\` (type=${t.type}) captured as ${r}`}return`Object captured as ${r} with keys: ${n}`}function on(t){try{const e=Object.getPrototypeOf(t);return e?e.constructor.name:void 0}catch(t){}}function sn(t){for(const e in t)if(Object.prototype.hasOwnProperty.call(t,e)){const n=t[e];if(n instanceof Error)return n}}const an=5e3;class BrowserClient extends w{
/**
   * Creates a new Browser SDK instance.
   *
   * @param options Configuration options for this SDK.
   */
constructor(t){const e={parentSpanIsAlwaysRootSpan:true,...t};const n=Ee.SENTRY_SDK_SOURCE||k();I(e,"browser",["browser"],n);super(e);const r=this;const{sendDefaultPii:o,_experiments:s}=r._options;const a=s?.enableLogs;e.sendClientReports&&Ee.document&&Ee.document.addEventListener("visibilitychange",(()=>{if(Ee.document.visibilityState==="hidden"){this._flushOutcomes();a&&P(r)}}));if(a){r.on("flush",(()=>{P(r)}));r.on("afterCaptureLog",(()=>{r._logFlushIdleTimeout&&clearTimeout(r._logFlushIdleTimeout);r._logFlushIdleTimeout=setTimeout((()=>{P(r)}),an)}))}if(o){r.on("postprocessEvent",R);r.on("beforeSendSession",C)}}eventFromException(t,e){return Ze(this._options.stackParser,t,e,this._options.attachStacktrace)}eventFromMessage(t,e="info",n){return tn(this._options.stackParser,t,e,n,this._options.attachStacktrace)}_prepareEvent(t,e,n,r){t.platform=t.platform||"javascript";return super._prepareEvent(t,e,n,r)}}function cn(t,e=ie("fetch")){let n=0;let r=0;function o(o){const s=o.body.length;n+=s;r++;const a={body:o.body,method:"POST",referrerPolicy:"strict-origin",headers:t.headers,keepalive:n<=6e4&&r<15,...t.fetchOptions};if(!e){ce("fetch");return O("No fetch implementation available")}try{return e(t.url,a).then((t=>{n-=s;r--;return{statusCode:t.status,headers:{"x-sentry-rate-limits":t.headers.get("X-Sentry-Rate-Limits"),"retry-after":t.headers.get("Retry-After")}}}))}catch(t){ce("fetch");n-=s;r--;return O(t)}}return q(t,o)}const un=10;const ln=20;const fn=30;const pn=40;const dn=50;function mn(t,e,n,r){const o={filename:t,function:e==="<anonymous>"?L:e,in_app:true};n!==void 0&&(o.lineno=n);r!==void 0&&(o.colno=r);return o}const gn=/^\s*at (\S+?)(?::(\d+))(?::(\d+))\s*$/i;const hn=/^\s*at (?:(.+?\)(?: \[.+\])?|.*?) ?\((?:address at )?)?(?:async )?((?:<anonymous>|[-a-z]+:|.*bundle|\/)?.*?)(?::(\d+))?(?::(\d+))?\)?\s*$/i;const yn=/\((\S*)(?::(\d+))(?::(\d+))\)/;const vn=t=>{const e=gn.exec(t);if(e){const[,t,n,r]=e;return mn(t,L,+n,+r)}const n=hn.exec(t);if(n){const t=n[2]&&n[2].indexOf("eval")===0;if(t){const t=yn.exec(n[2]);if(t){n[2]=t[1];n[3]=t[2];n[4]=t[3]}}const[e,r]=An(n[1]||L,n[2]);return mn(r,e,n[3]?+n[3]:void 0,n[4]?+n[4]:void 0)}};const _n=[fn,vn];const bn=/^\s*(.*?)(?:\((.*?)\))?(?:^|@)?((?:[-a-z]+)?:\/.*?|\[native code\]|[^@]*(?:bundle|\d+\.js)|\/[\w\-. /=]+)(?::(\d+))?(?::(\d+))?\s*$/i;const Sn=/(\S+) line (\d+)(?: > eval line \d+)* > eval/i;const xn=t=>{const e=bn.exec(t);if(e){const t=e[3]&&e[3].indexOf(" > eval")>-1;if(t){const t=Sn.exec(e[3]);if(t){e[1]=e[1]||"eval";e[3]=t[1];e[4]=t[2];e[5]=""}}let n=e[3];let r=e[1]||L;[r,n]=An(r,n);return mn(n,r,e[4]?+e[4]:void 0,e[5]?+e[5]:void 0)}};const Tn=[dn,xn];const En=/^\s*at (?:((?:\[object object\])?.+) )?\(?((?:[-a-z]+):.*?):(\d+)(?::(\d+))?\)?\s*$/i;const wn=t=>{const e=En.exec(t);return e?mn(e[2],e[1]||L,+e[3],e[4]?+e[4]:void 0):void 0};const kn=[pn,wn];const In=/ line (\d+).*script (?:in )?(\S+)(?:: in function (\S+))?$/i;const Pn=t=>{const e=In.exec(t);return e?mn(e[2],e[3]||L,+e[1]):void 0};const Rn=[un,Pn];const Cn=/ line (\d+), column (\d+)\s*(?:in (?:<anonymous function: ([^>]+)>|([^)]+))\(.*\))? in (.*):\s*$/i;const On=t=>{const e=Cn.exec(t);return e?mn(e[5],e[3]||e[4]||L,+e[1],+e[2]):void 0};const qn=[ln,On];const Ln=[_n,Tn];const $n=$(...Ln);const An=(t,e)=>{const n=t.indexOf("safari-extension")!==-1;const r=t.indexOf("safari-web-extension")!==-1;return n||r?[t.indexOf("@")!==-1?t.split("@")[0]:L,n?`safari-extension:${e}`:`safari-web-extension:${e}`]:[t,e]};function Dn(t,{metadata:e,tunnel:n,dsn:r}){const o={event_id:t.event_id,sent_at:(new Date).toISOString(),...e?.sdk&&{sdk:{name:e.sdk.name,version:e.sdk.version}},...!!n&&!!r&&{dsn:A(r)}};const s=Fn(t);return D(o,[s])}function Fn(t){const e={type:"user_report"};return[e,t]}const Nn=typeof __SENTRY_DEBUG__==="undefined"||__SENTRY_DEBUG__;const Hn=1024;const Mn="Breadcrumbs";const jn=(t={})=>{const e={console:true,dom:true,fetch:true,history:true,sentry:true,xhr:true,...t};return{name:Mn,setup(t){e.console&&F(Wn(t));e.dom&&ue(zn(t,e.dom));e.xhr&&le(Xn(t));e.fetch&&N(Gn(t));e.history&&fe(Yn(t));e.sentry&&t.on("beforeSendEvent",Un(t))}}};const Bn=H(jn);function Un(t){return function(e){f()===t&&M({category:"sentry."+(e.type==="transaction"?"transaction":"event"),event_id:e.event_id,level:e.level,message:j(e)},{event:e})}}function zn(t,e){return function(n){if(f()!==t)return;let r;let o;let s=typeof e==="object"?e.serializeAttribute:void 0;let a=typeof e==="object"&&typeof e.maxStringLength==="number"?e.maxStringLength:void 0;if(a&&a>Hn){Nn&&B.warn(`\`dom.maxStringLength\` cannot exceed ${Hn}, but a value of ${a} was configured. Sentry will use ${Hn} instead.`);a=Hn}typeof s==="string"&&(s=[s]);try{const t=n.event;const e=Vn(t)?t.target:t;r=U(e,{keyAttrs:s,maxStringLength:a});o=z(e)}catch(t){r="<unknown>"}if(r.length===0)return;const i={category:`ui.${n.name}`,message:r};o&&(i.data={"ui.component_name":o});M(i,{event:n.event,name:n.name,global:n.global})}}function Wn(t){return function(e){if(f()!==t)return;const n={category:"console",data:{arguments:e.args,logger:"console"},level:X(e.level),message:W(e.args," ")};if(e.level==="assert"){if(e.args[0]!==false)return;n.message=`Assertion failed: ${W(e.args.slice(1)," ")||"console.assert"}`;n.data.arguments=e.args.slice(1)}M(n,{input:e.args,level:e.level})}}function Xn(t){return function(e){if(f()!==t)return;const{startTimestamp:n,endTimestamp:r}=e;const o=e.xhr[pe];if(!n||!r||!o)return;const{method:s,url:a,status_code:i,body:c}=o;const u={method:s,url:a,status_code:i};const l={xhr:e.xhr,input:c,startTimestamp:n,endTimestamp:r};const p={category:"xhr",data:u,type:"http",level:G(i)};t.emit("beforeOutgoingRequestBreadcrumb",p,l);M(p,l)}}function Gn(t){return function(e){if(f()!==t)return;const{startTimestamp:n,endTimestamp:r}=e;if(r&&(!e.fetchData.url.match(/sentry_key/)||e.fetchData.method!=="POST")){({method:e.fetchData.method,url:e.fetchData.url});if(e.error){const o=e.fetchData;const s={data:e.error,input:e.args,startTimestamp:n,endTimestamp:r};const a={category:"fetch",data:o,level:"error",type:"http"};t.emit("beforeOutgoingRequestBreadcrumb",a,s);M(a,s)}else{const o=e.response;const s={...e.fetchData,status_code:o?.status};e.fetchData.request_body_size;e.fetchData.response_body_size;o?.status;const a={input:e.args,response:o,startTimestamp:n,endTimestamp:r};const i={category:"fetch",data:s,type:"http",level:G(s.status_code)};t.emit("beforeOutgoingRequestBreadcrumb",i,a);M(i,a)}}}}function Yn(t){return function(e){if(f()!==t)return;let n=e.from;let r=e.to;const o=Y(Ee.location.href);let s=n?Y(n):void 0;const a=Y(r);s?.path||(s=o);o.protocol===a.protocol&&o.host===a.host&&(r=a.relative);o.protocol===s.protocol&&o.host===s.host&&(n=s.relative);M({category:"navigation",data:{from:n,to:r}})}}function Vn(t){return!!t&&!!t.target}const Kn=["EventTarget","Window","Node","ApplicationCache","AudioTrackList","BroadcastChannel","ChannelMergerNode","CryptoOperation","EventSource","FileReader","HTMLUnknownElement","IDBDatabase","IDBRequest","IDBTransaction","KeyOperation","MediaController","MessagePort","ModalWindow","Notification","SVGElementInstance","Screen","SharedWorker","TextTrack","TextTrackCue","TextTrackList","WebSocket","WebSocketWorker","Worker","XMLHttpRequest","XMLHttpRequestEventTarget","XMLHttpRequestUpload"];const Jn="BrowserApiErrors";const Qn=(t={})=>{const e={XMLHttpRequest:true,eventTarget:true,requestAnimationFrame:true,setInterval:true,setTimeout:true,...t};return{name:Jn,setupOnce(){e.setTimeout&&V(Ee,"setTimeout",tr);e.setInterval&&V(Ee,"setInterval",tr);e.requestAnimationFrame&&V(Ee,"requestAnimationFrame",er);e.XMLHttpRequest&&"XMLHttpRequest"in Ee&&V(XMLHttpRequest.prototype,"send",nr);const t=e.eventTarget;if(t){const e=Array.isArray(t)?t:Kn;e.forEach(rr)}}}};const Zn=H(Qn);function tr(t){return function(...e){const n=e[0];e[0]=Pe(n,{mechanism:{data:{function:K(t)},handled:false,type:"instrument"}});return t.apply(this,e)}}function er(t){return function(e){return t.apply(this,[Pe(e,{mechanism:{data:{function:"requestAnimationFrame",handler:K(t)},handled:false,type:"instrument"}})])}}function nr(t){return function(...e){const n=this;const r=["onload","onerror","onprogress","onreadystatechange"];r.forEach((t=>{t in n&&typeof n[t]==="function"&&V(n,t,(function(e){const n={mechanism:{data:{function:t,handler:K(e)},handled:false,type:"instrument"}};const r=o(e);r&&(n.mechanism.data.handler=K(r));return Pe(e,n)}))}));return t.apply(this,e)}}function rr(t){const e=Ee;const n=e[t]?.prototype;if(n?.hasOwnProperty?.("addEventListener")){V(n,"addEventListener",(function(e){return function(n,r,o){try{or(r)&&(r.handleEvent=Pe(r.handleEvent,{mechanism:{data:{function:"handleEvent",handler:K(r),target:t},handled:false,type:"instrument"}}))}catch{}return e.apply(this,[n,Pe(r,{mechanism:{data:{function:"addEventListener",handler:K(r),target:t},handled:false,type:"instrument"}}),o])}}));V(n,"removeEventListener",(function(t){return function(e,n,r){try{const o=n.__sentry_wrapped__;o&&t.call(this,e,o,r)}catch(t){}return t.call(this,e,n,r)}}))}}function or(t){return typeof t.handleEvent==="function"}const sr=H((()=>({name:"BrowserSession",setupOnce(){if(typeof Ee.document!=="undefined"){J({ignoreDuration:true});Q();fe((({from:t,to:e})=>{if(t!==void 0&&t!==e){J({ignoreDuration:true});Q()}}))}else Nn&&B.warn("Using the `browserSessionIntegration` in non-browser environments is not supported.")}})));const ar="GlobalHandlers";const ir=(t={})=>{const e={onerror:true,onunhandledrejection:true,...t};return{name:ar,setupOnce(){Error.stackTraceLimit=50},setup(t){if(e.onerror){ur(t);mr("onerror")}if(e.onunhandledrejection){lr(t);mr("onunhandledrejection")}}}};const cr=H(ir);function ur(t){Z((e=>{const{stackParser:n,attachStacktrace:r}=gr();if(f()!==t||ke())return;const{msg:o,url:s,line:a,column:i,error:c}=e;const u=dr(en(n,c||o,void 0,r,false),s,a,i);u.level="error";tt(u,{originalException:c,mechanism:{handled:false,type:"onerror"}})}))}function lr(t){et((e=>{const{stackParser:n,attachStacktrace:r}=gr();if(f()!==t||ke())return;const o=fr(e);const s=nt(o)?pr(o):en(n,o,void 0,r,true);s.level="error";tt(s,{originalException:o,mechanism:{handled:false,type:"onunhandledrejection"}})}))}function fr(t){if(nt(t))return t;try{if("reason"in t)return t.reason;if("detail"in t&&"reason"in t.detail)return t.detail.reason}catch{}return t}
/**
 * Create an event from a promise rejection where the `reason` is a primitive.
 *
 * @param reason: The `reason` property of the promise rejection
 * @returns An Event object with an appropriate `exception` value
 */function pr(t){return{exception:{values:[{type:"UnhandledRejection",value:`Non-Error promise rejection captured with value: ${String(t)}`}]}}}function dr(t,e,n,r){const o=t.exception=t.exception||{};const s=o.values=o.values||[];const a=s[0]=s[0]||{};const i=a.stacktrace=a.stacktrace||{};const c=i.frames=i.frames||[];const u=r;const l=n;const f=rt(e)&&e.length>0?e:ot();c.length===0&&c.push({colno:u,filename:f,function:L,in_app:true,lineno:l});return t}function mr(t){Nn&&B.log(`Global Handler attached: ${t}`)}function gr(){const t=f();const e=t?.getOptions()||{stackParser:()=>[],attachStacktrace:false};return e}const hr=H((()=>({name:"HttpContext",preprocessEvent(t){if(!Ee.navigator&&!Ee.location&&!Ee.document)return;const e=t.request?.url||ot();const{referrer:n}=Ee.document||{};const{userAgent:r}=Ee.navigator||{};const o={...t.request?.headers,...n&&{Referer:n},...r&&{"User-Agent":r}};const s={...t.request,...e&&{url:e},headers:o};t.request=s}})));const yr="cause";const vr=5;const _r="LinkedErrors";const br=(t={})=>{const e=t.limit||vr;const n=t.key||yr;return{name:_r,preprocessEvent(t,r,o){const s=o.getOptions();st(Ue,s.stackParser,n,e,t,r)}}};const Sr=H(br);function xr(t){return[at(),it(),Zn(),Bn(),cr(),Sr(),ct(),hr(),sr()]}function Tr(t={}){const e={defaultIntegrations:xr(),release:typeof __SENTRY_RELEASE__==="string"?__SENTRY_RELEASE__:Ee.SENTRY_RELEASE?.id,sendClientReports:true};return{...e,...Er(t)}}function Er(t){const e={};for(const n of Object.getOwnPropertyNames(t)){const r=n;t[r]!==void 0&&(e[r]=t[r])}return e}function wr(){const t=typeof Ee.window!=="undefined"&&Ee;if(!t)return false;const e=t.chrome?"chrome":"browser";const n=t[e];const r=n?.runtime?.id;const o=ot()||"";const s=["chrome-extension:","moz-extension:","ms-browser-extension:","safari-web-extension:"];const a=!!r&&Ee===Ee.top&&s.some((t=>o.startsWith(`${t}//`)));const i=typeof t.nw!=="undefined";return!!r&&!a&&!i}function kr(t={}){const e=Tr(t);if(!e.skipBrowserExtensionCheck&&wr()){Nn&&ut((()=>{console.error("[Sentry] You cannot run Sentry this way in a browser extension, check: https://docs.sentry.io/platforms/javascript/best-practices/browser-extensions/")}));return}Nn&&!lt()&&B.warn("No Fetch API detected. The Sentry SDK requires a Fetch API compatible environment to send events. Please add a Fetch API polyfill.");const n={...e,stackParser:pt(e.stackParser||$n),integrations:ft(e),transport:e.transport||cn};return dt(BrowserClient,n)}
/**
 * Present the user with a report dialog.
 *
 * @param options Everything is optional, we try to fetch all info need from the global scope.
 */function Ir(t={}){if(!Ee.document){Nn&&B.error("Global document not defined in showReportDialog call");return}const e=mt();const n=e.getClient();const r=n?.getDsn();if(!r){Nn&&B.error("DSN not configured for showReportDialog call");return}e&&(t.user={...e.getUser(),...t.user});if(!t.eventId){const e=gt();e&&(t.eventId=e)}const o=Ee.document.createElement("script");o.async=true;o.crossOrigin="anonymous";o.src=ht(r,t);t.onLoad&&(o.onload=t.onLoad);const{onClose:s}=t;if(s){const t=e=>{if(e.data==="__sentry_reportdialog_closed__")try{s()}finally{Ee.removeEventListener("message",t)}};Ee.addEventListener("message",t)}const a=Ee.document.head||Ee.document.body;a?a.appendChild(o):Nn&&B.error("Not injecting report dialog. No injection point found in HTML")}function Pr(){}function Rr(t){t()}const Cr=r;const Or="ReportingObserver";const qr=new WeakMap;const Lr=(t={})=>{const e=t.types||["crash","deprecation","intervention"];function n(t){if(qr.has(f()))for(const e of t)s((t=>{t.setExtra("url",e.url);const n=`ReportingObserver [${e.type}]`;let r="No details available";if(e.body){const n={};for(const t in e.body)n[t]=e.body[t];t.setExtra("body",n);if(e.type==="crash"){const t=e.body;r=[t.crashId||"",t.reason||""].join(" ").trim()||r}else{const t=e.body;r=t.message||r}}yt(`${n}: ${r}`)}))}return{name:Or,setupOnce(){if(!vt())return;const t=new Cr.ReportingObserver(n,{buffered:true,types:e});t.observe()},setup(t){qr.set(t,true)}}};const $r=H(Lr);const Ar="HttpClient";const Dr=(t={})=>{const e={failedRequestStatusCodes:[[500,599]],failedRequestTargets:[/.*/],...t};return{name:Ar,setup(t){Gr(t,e);Yr(t,e)}}};const Fr=H(Dr);
/**
 * Interceptor function for fetch requests
 *
 * @param requestInfo The Fetch API request info
 * @param response The Fetch API response
 * @param requestInit The request init object
 */function Nr(t,e,n,r,o){if(Vr(t,n.status,n.url)){const t=Jr(e,r);let s,a,i,c;if(Qr()){[s,i]=Hr("Cookie",t);[a,c]=Hr("Set-Cookie",n)}const u=Kr({url:t.url,method:t.method,status:n.status,requestHeaders:s,responseHeaders:a,requestCookies:i,responseCookies:c,error:o});tt(u)}}function Hr(t,e){const n=Ur(e.headers);let r;try{const e=n[t]||n[t.toLowerCase()]||void 0;e&&(r=Br(e))}catch{}return[n,r]}
/**
 * Interceptor function for XHR requests
 *
 * @param xhr The XHR request
 * @param method The HTTP method
 * @param headers The HTTP headers
 */function Mr(t,e,n,r,o){if(Vr(t,e.status,e.responseURL)){let t,s,a;if(Qr()){try{const t=e.getResponseHeader("Set-Cookie")||e.getResponseHeader("set-cookie")||void 0;t&&(s=Br(t))}catch{}try{a=zr(e)}catch{}t=r}const i=Kr({url:e.responseURL,method:n,status:e.status,requestHeaders:t,responseHeaders:a,responseCookies:s,error:o});tt(i)}}
/**
 * Extracts response size from `Content-Length` header when possible
 *
 * @param headers
 * @returns The response size in bytes or undefined
 */function jr(t){if(t){const e=t["Content-Length"]||t["content-length"];if(e)return parseInt(e,10)}}
/**
 * Creates an object containing cookies from the given cookie string
 *
 * @param cookieString The cookie string to parse
 * @returns The parsed cookies
 */function Br(t){return t.split("; ").reduce(((t,e)=>{const[n,r]=e.split("=");n&&r&&(t[n]=r);return t}),{})}
/**
 * Extracts the headers as an object from the given Fetch API request or response object
 *
 * @param headers The headers to extract
 * @returns The extracted headers as an object
 */function Ur(t){const e={};t.forEach(((t,n)=>{e[n]=t}));return e}
/**
 * Extracts the response headers as an object from the given XHR object
 *
 * @param xhr The XHR object to extract the response headers from
 * @returns The response headers as an object
 */function zr(t){const e=t.getAllResponseHeaders();return e?e.split("\r\n").reduce(((t,e)=>{const[n,r]=e.split(": ");n&&r&&(t[n]=r);return t}),{}):{}}
/**
 * Checks if the given target url is in the given list of targets
 *
 * @param target The target url to check
 * @returns true if the target url is in the given list of targets, false otherwise
 */function Wr(t,e){return t.some((t=>typeof t==="string"?e.includes(t):t.test(e)))}
/**
 * Checks if the given status code is in the given range
 *
 * @param status The status code to check
 * @returns true if the status code is in the given range, false otherwise
 */function Xr(t,e){return t.some((t=>typeof t==="number"?t===e:e>=t[0]&&e<=t[1]))}function Gr(t,e){_t()&&N((n=>{if(f()!==t)return;const{response:r,args:o,error:s,virtualError:a}=n;const[i,c]=o;r&&Nr(e,i,r,c,s||a)}),false)}function Yr(t,e){"XMLHttpRequest"in r&&le((n=>{if(f()!==t)return;const{error:r,virtualError:o}=n;const s=n.xhr;const a=s[pe];if(!a)return;const{method:i,request_headers:c}=a;try{Mr(e,s,i,c,r||o)}catch(t){Nn&&B.warn("Error while extracting response event form XHR response",t)}}))}
/**
 * Checks whether to capture given response as an event
 *
 * @param status response status code
 * @param url response url
 */function Vr(t,e,n){return Xr(t.failedRequestStatusCodes,e)&&Wr(t.failedRequestTargets,n)&&!bt(n,f())}
/**
 * Creates a synthetic Sentry event from given response data
 *
 * @param data response data
 * @returns event
 */function Kr(t){const e=f();const n=e&&t.error&&t.error instanceof Error?t.error.stack:void 0;const r=n&&e?e.getOptions().stackParser(n,0,1):void 0;const o=`HTTP Client Error with status code: ${t.status}`;const s={message:o,exception:{values:[{type:"Error",value:o,stacktrace:r?{frames:r}:void 0}]},request:{url:t.url,method:t.method,headers:t.requestHeaders,cookies:t.requestCookies},contexts:{response:{status_code:t.status,headers:t.responseHeaders,cookies:t.responseCookies,body_size:jr(t.responseHeaders)}}};i(s,{type:"http.client",handled:false});return s}function Jr(t,e){return!e&&t instanceof Request||t instanceof Request&&t.bodyUsed?t:new Request(t,e)}function Qr(){const t=f();return!!t&&Boolean(t.getOptions().sendDefaultPii)}const Zr=r;const to=7;const eo="ContextLines";const no=(t={})=>{const e=t.frameContextLines!=null?t.frameContextLines:to;return{name:eo,processEvent(t){return oo(t,e)}}};const ro=H(no);function oo(t,e){const n=Zr.document;const r=Zr.location&&St(Zr.location.href);if(!n||!r)return t;const o=t.exception?.values;if(!o?.length)return t;const s=n.documentElement.innerHTML;if(!s)return t;const a=["<!DOCTYPE html>","<html>",...s.split("\n"),"</html>"];o.forEach((t=>{const n=t.stacktrace;n?.frames&&(n.frames=n.frames.map((t=>so(t,a,r,e))))}));return t}function so(t,e,n,r){if(t.filename!==n||!t.lineno||!e.length)return t;xt(e,t,r);return t}const ao="GraphQLClient";const io=t=>({name:ao,setup(e){co(e,t);uo(e,t)}});function co(t,e){t.on("beforeOutgoingRequestSpan",((t,n)=>{const r=Tt(t);const o=r.data||{};const s=o[Et];const a=s==="http.client";if(!a)return;const i=o[wt]||o["http.url"];const c=o[kt]||o["http.method"];if(!rt(i)||!rt(c))return;const{endpoints:u}=e;const l=It(i,u);const f=fo(n);if(l&&f){const e=mo(f);if(e){const n=lo(e);t.updateName(`${c} ${i} (${n})`);t.setAttribute("graphql.document",f)}}}))}function uo(t,e){t.on("beforeOutgoingRequestBreadcrumb",((t,n)=>{const{category:r,type:o,data:s}=t;const a=r==="fetch";const i=r==="xhr";const c=o==="http";if(c&&(a||i)){const t=s?.url;const{endpoints:r}=e;const o=It(t,r);const a=fo(n);if(o&&s&&a){const t=mo(a);if(!s.graphql&&t){const e=lo(t);s["graphql.document"]=t.query;s["graphql.operation"]=e}}}}))}
/**
 * @param requestBody - GraphQL request
 * @returns A formatted version of the request: 'TYPE NAME' or 'TYPE'
 */function lo(t){const{query:e,operationName:n}=t;const{operationName:r=n,operationType:o}=po(e);const s=r?`${o} ${r}`:`${o}`;return s}function fo(t){const e="xhr"in t;let n;if(e){const e=t.xhr[pe];n=e&&de(e.body)[0]}else{const e=me(t.input);n=de(e)[0]}return n}function po(t){const e=/^(?:\s*)(query|mutation|subscription)(?:\s*)(\w+)(?:\s*)[{(]/;const n=/^(?:\s*)(query|mutation|subscription)(?:\s*)[{(]/;const r=t.match(e);if(r)return{operationType:r[1],operationName:r[2]};const o=t.match(n);return o?{operationType:o[1],operationName:void 0}:{operationType:void 0,operationName:void 0}}
/**
 * Extract the payload of a request if it's GraphQL.
 * Exported for tests only.
 * @param payload - A valid JSON string
 * @returns A POJO or undefined
 */function mo(t){let e;try{const n=JSON.parse(t);const r=!!n.query;r&&(e=n)}finally{return e}}const go=H(io);const ho=new WeakMap;const yo=new Map;const vo={traceFetch:true,traceXHR:true,enableHTTPTimings:true,trackFetchStreamPerformance:false};function _o(t,e){const{traceFetch:n,traceXHR:r,trackFetchStreamPerformance:o,shouldCreateSpanForRequest:s,enableHTTPTimings:a,tracePropagationTargets:i,onRequestSpanStart:c}={...vo,...e};const u=typeof s==="function"?s:t=>true;const l=t=>Eo(t,i);const f={};if(n){t.addEventProcessor((t=>{t.type==="transaction"&&t.spans&&t.spans.forEach((t=>{if(t.op==="http.client"){const e=yo.get(t.span_id);if(e){t.timestamp=e/1e3;yo.delete(t.span_id)}}}));return t}));o&&Pt((t=>{if(t.response){const e=ho.get(t.response);e&&t.endTimestamp&&yo.set(e,t.endTimestamp)}}));N((t=>{const e=Rt(t,u,l,f);t.response&&t.fetchData.__span&&ho.set(t.response,t.fetchData.__span);if(e){const n=Ro(t.fetchData.url);const r=n?Y(n).host:void 0;e.setAttributes({"http.url":n,"server.address":r});a&&So(e);c?.(e,{headers:t.headers})}}))}r&&le((t=>{const e=wo(t,u,l,f);if(e){a&&So(e);let n;try{n=new Headers(t.xhr.__sentry_xhr_v3__?.request_headers)}catch{}c?.(e,{headers:n})}}))}function bo(t){return t.entryType==="resource"&&"initiatorType"in t&&typeof t.nextHopProtocol==="string"&&(t.initiatorType==="fetch"||t.initiatorType==="xmlhttprequest")}
/**
 * Creates a temporary observer to listen to the next fetch/xhr resourcing timings,
 * so that when timings hit their per-browser limit they don't need to be removed.
 *
 * @param span A span that has yet to be finished, must contain `url` on data.
 */function So(t){const{url:e}=Tt(t).data;if(!e||typeof e!=="string")return;const n=ge("resource",(({entries:r})=>{r.forEach((r=>{if(bo(r)&&r.name.endsWith(e)){const e=To(r);e.forEach((e=>t.setAttribute(...e)));setTimeout(n)}}))}))}function xo(t=0){return((Ct()||performance.timeOrigin)+t)/1e3}function To(t){const{name:e,version:n}=he(t.nextHopProtocol);const r=[];r.push(["network.protocol.version",n],["network.protocol.name",e]);return Ct()?[...r,["http.request.redirect_start",xo(t.redirectStart)],["http.request.fetch_start",xo(t.fetchStart)],["http.request.domain_lookup_start",xo(t.domainLookupStart)],["http.request.domain_lookup_end",xo(t.domainLookupEnd)],["http.request.connect_start",xo(t.connectStart)],["http.request.secure_connection_start",xo(t.secureConnectionStart)],["http.request.connection_end",xo(t.connectEnd)],["http.request.request_start",xo(t.requestStart)],["http.request.response_start",xo(t.responseStart)],["http.request.response_end",xo(t.responseEnd)]]:r}function Eo(t,e){const n=ot();if(n){let r;let o;try{r=new URL(t,n);o=new URL(n).origin}catch(t){return false}const s=r.origin===o;return e?It(r.toString(),e)||s&&It(r.pathname,e):s}{const n=!!t.match(/^\/(?!\/)/);return e?It(t,e):n}}
/**
 * Create and track xhr request spans
 *
 * @returns Span if a span was created, otherwise void.
 */function wo(t,e,n,r){const o=t.xhr;const s=o?.[pe];if(!o||o.__sentry_own_request__||!s)return;const{url:a,method:i}=s;const c=Ot()&&e(a);if(t.endTimestamp&&c){const t=o.__sentry_xhr_span_id__;if(!t)return;const e=r[t];if(e&&s.status_code!==void 0){qt(e,s.status_code);e.end();delete r[t]}return}const u=Ro(a);const l=Y(u||a);const p=St(a);const d=!!Lt();const m=c&&d?$t({name:`${i} ${p}`,attributes:{url:a,type:"xhr","http.method":i,"http.url":u,"server.address":l?.host,[At]:"auto.http.browser",[Et]:"http.client",...l?.search&&{"http.query":l?.search},...l?.hash&&{"http.fragment":l?.hash}}}):new Dt;o.__sentry_xhr_span_id__=m.spanContext().spanId;r[o.__sentry_xhr_span_id__]=m;n(a)&&ko(o,Ot()&&d?m:void 0);const g=f();g&&g.emit("beforeOutgoingRequestSpan",m,t);return m}function ko(t,e){const{"sentry-trace":n,baggage:r}=Ft({span:e});n&&Io(t,n,r)}function Io(t,e,n){const r=t.__sentry_xhr_v3__?.request_headers;if(!r?.["sentry-trace"])try{t.setRequestHeader("sentry-trace",e);if(n){const e=r?.baggage;e&&Po(e)||t.setRequestHeader("baggage",n)}}catch(t){}}function Po(t){return t.split(",").some((t=>t.trim().startsWith("sentry-")))}function Ro(t){try{const e=new URL(t,Ee.location.origin);return e.href}catch{return}}function Co(){Ee.document?Ee.document.addEventListener("visibilitychange",(()=>{const t=Lt();if(!t)return;const e=Nt(t);if(Ee.document.hidden&&e){const t="cancelled";const{op:n,status:r}=Tt(e);Nn&&B.log(`[Tracing] Transaction: ${t} -> since tab moved to the background, op: ${n}`);r||e.setStatus({code:Ht,message:t});e.setAttribute("sentry.cancellation_reason","document.hidden");e.end()}})):Nn&&B.warn("[Tracing] Could not set up background tab detection due to lack of global document")}const Oo=3600;const qo="sentry_previous_trace";const Lo="sentry.previous_trace";
/**
 * Takes care of linking traces and applying the (consistent) sampling behavoiour based on the passed options
 * @param options - options for linking traces and consistent trace sampling (@see BrowserTracingOptions)
 * @param client - Sentry client
 */function $o(t,{linkPreviousTrace:e,consistentTraceSampling:n}){const r=e==="session-storage";let o=r?Fo():void 0;t.on("spanStart",(t=>{if(Nt(t)!==t)return;const e=mt().getPropagationContext();o=Ao(o,t,e);r&&Do(o)}));let s=true;n&&t.on("beforeSampling",(t=>{if(!o)return;const e=mt();const n=e.getPropagationContext();if(s&&n.parentSpanId)s=false;else{e.setPropagationContext({...n,dsc:{...n.dsc,sample_rate:String(o.sampleRate),sampled:String(No(o.spanContext))},sampleRand:o.sampleRand});t.parentSampled=No(o.spanContext);t.parentSampleRate=o.sampleRate;t.spanAttributes={...t.spanAttributes,[Mt]:o.sampleRate}}}))}
/**
 * Adds a previous_trace span link to the passed span if the passed
 * previousTraceInfo is still valid.
 *
 * @returns the updated previous trace info (based on the current span/trace) to
 * be used on the next call
 */function Ao(t,e,n){const r=Tt(e);function o(){try{return Number(n.dsc?.sample_rate)??Number(r.data?.[jt])}catch{return 0}}const s={spanContext:e.spanContext(),startTimestamp:r.start_timestamp,sampleRate:o(),sampleRand:n.sampleRand};if(!t)return s;const a=t.spanContext;if(a.traceId===r.trace_id)return t;if(Date.now()/1e3-t.startTimestamp<=Oo){Nn&&B.info(`Adding previous_trace ${a} link to span ${{op:r.op,...e.spanContext()}}`);e.addLink({context:a,attributes:{[Bt]:"previous_trace"}});e.setAttribute(Lo,`${a.traceId}-${a.spanId}-${No(a)?1:0}`)}return s}
/**
 * Stores @param previousTraceInfo in sessionStorage.
 */function Do(t){try{Ee.sessionStorage.setItem(qo,JSON.stringify(t))}catch(t){Nn&&B.warn("Could not store previous trace in sessionStorage",t)}}function Fo(){try{const t=Ee.sessionStorage?.getItem(qo);return JSON.parse(t)}catch(t){return}}function No(t){return t.traceFlags===1}const Ho="BrowserTracing";const Mo={...Ut,instrumentNavigation:true,instrumentPageLoad:true,markBackgroundSpan:true,enableLongTask:true,enableLongAnimationFrame:true,enableInp:true,linkPreviousTrace:"in-memory",consistentTraceSampling:false,_experiments:{},...vo};let jo=false;const Bo=(t={})=>{jo&&ut((()=>{console.warn("Multiple browserTracingIntegration instances are not supported.")}));jo=true;const e=Ee.document;zt();const{enableInp:n,enableLongTask:o,enableLongAnimationFrame:s,_experiments:{enableInteractions:a,enableStandaloneClsSpans:i},beforeStartSpan:c,idleTimeout:u,finalTimeout:l,childSpanTimeout:p,markBackgroundSpan:d,traceFetch:m,traceXHR:g,trackFetchStreamPerformance:h,shouldCreateSpanForRequest:y,enableHTTPTimings:v,instrumentPageLoad:_,instrumentNavigation:b,linkPreviousTrace:S,consistentTraceSampling:x,onRequestSpanStart:T}={...Mo,...t};const E=ye({recordClsStandaloneSpans:i||false});n&&ve();s&&r.PerformanceObserver&&PerformanceObserver.supportedEntryTypes&&PerformanceObserver.supportedEntryTypes.includes("long-animation-frame")?_e():o&&be();a&&Se();const w={name:void 0,source:void 0};function k(t,n){const r=n.op==="pageload";const o=c?c(n):n;const s=o.attributes||{};if(n.name!==o.name){s[Wt]="custom";o.attributes=s}w.name=o.name;w.source=s[Wt];const a=Xt(o,{idleTimeout:u,finalTimeout:l,childSpanTimeout:p,disableAutoFinish:r,beforeSpanEnd:e=>{E();xe(e,{recordClsOnPageloadSpan:!i});Vo(t,void 0);const n=mt();const r=n.getPropagationContext();n.setPropagationContext({...r,traceId:a.spanContext().traceId,sampled:Yt(a),dsc:Gt(e)})}});Vo(t,a);function f(){e&&["interactive","complete"].includes(e.readyState)&&t.emit("idleSpanEnableAutoFinish",a)}if(r&&e){e.addEventListener("readystatechange",(()=>{f()}));f()}}return{name:Ho,afterAllSetup(t){let e=ot();function r(){const e=Yo(t);if(e&&!Tt(e).timestamp){Nn&&B.log(`[Tracing] Finishing current active span with op: ${Tt(e).op}`);e.end()}}t.on("startNavigationSpan",(e=>{if(f()===t){r();Vt().setPropagationContext({traceId:Kt(),sampleRand:Math.random()});mt().setPropagationContext({traceId:Kt(),sampleRand:Math.random()});k(t,{op:"navigation",...e})}}));t.on("startPageLoadSpan",((e,n={})=>{if(f()!==t)return;r();const o=n.sentryTrace||Wo("sentry-trace");const s=n.baggage||Wo("baggage");const a=Jt(o,s);mt().setPropagationContext(a);k(t,{op:"pageload",...e})}));S!=="off"&&$o(t,{linkPreviousTrace:S,consistentTraceSampling:x});if(Ee.location){if(_){const e=Ct();Uo(t,{name:Ee.location.pathname,startTime:e?e/1e3:void 0,attributes:{[Wt]:"url",[At]:"auto.pageload.browser"}})}b&&fe((({to:n,from:r})=>{if(r!==void 0||e?.indexOf(n)===-1){if(r!==n){e=void 0;zo(t,{name:Ee.location.pathname,attributes:{[Wt]:"url",[At]:"auto.navigation.browser"}})}}else e=void 0}))}d&&Co();a&&Xo(t,u,l,p,w);n&&Te();_o(t,{traceFetch:m,traceXHR:g,trackFetchStreamPerformance:h,tracePropagationTargets:t.getOptions().tracePropagationTargets,shouldCreateSpanForRequest:y,enableHTTPTimings:v,onRequestSpanStart:T})}}};function Uo(t,e,n){t.emit("startPageLoadSpan",e,n);mt().setTransactionName(e.name);return Yo(t)}function zo(t,e){t.emit("startNavigationSpan",e);mt().setTransactionName(e.name);return Yo(t)}function Wo(t){const e=Ee.document;const n=e?.querySelector(`meta[name=${t}]`);return n?.getAttribute("content")||void 0}function Xo(t,e,n,r,o){const s=Ee.document;let a;const i=()=>{const s="ui.action.click";const i=Yo(t);if(i){const t=Tt(i).op;if(["navigation","pageload"].includes(t)){Nn&&B.warn(`[Tracing] Did not create ${s} span because a pageload or navigation span is in progress.`);return}}if(a){a.setAttribute(Qt,"interactionInterrupted");a.end();a=void 0}o.name?a=Xt({name:o.name,op:s,attributes:{[Wt]:o.source||"url"}},{idleTimeout:e,finalTimeout:n,childSpanTimeout:r}):Nn&&B.warn(`[Tracing] Did not create ${s} transaction because _latestRouteName is missing.`)};s&&addEventListener("click",i,{once:false,capture:true})}const Go="_sentry_idleSpan";function Yo(t){return t[Go]}function Vo(t,e){l(t,Go,e)}function Ko(t){return new Promise(((e,n)=>{t.oncomplete=t.onsuccess=()=>e(t.result);t.onabort=t.onerror=()=>n(t.error)}))}function Jo(t,e){const n=indexedDB.open(t);n.onupgradeneeded=()=>n.result.createObjectStore(e);const r=Ko(n);return t=>r.then((n=>t(n.transaction(e,"readwrite").objectStore(e))))}function Qo(t){return Ko(t.getAllKeys())}function Zo(t,e,n){return t((t=>Qo(t).then((r=>{if(!(r.length>=n)){t.put(e,Math.max(...r,0)+1);return Ko(t.transaction)}}))))}function ts(t,e,n){return t((t=>Qo(t).then((r=>{if(!(r.length>=n)){t.put(e,Math.min(...r,0)-1);return Ko(t.transaction)}}))))}function es(t){return t((t=>Qo(t).then((e=>{const n=e[0];if(n!=null)return Ko(t.get(n)).then((e=>{t.delete(n);return Ko(t.transaction).then((()=>e))}))}))))}function ns(t){let e;function n(){e==void 0&&(e=Jo(t.dbName||"sentry-offline",t.storeName||"queue"));return e}return{push:async e=>{try{const r=await te(e);await Zo(n(),r,t.maxQueueSize||30)}catch(t){}},unshift:async e=>{try{const r=await te(e);await ts(n(),r,t.maxQueueSize||30)}catch(t){}},shift:async()=>{try{const t=await es(n());if(t)return Zt(t)}catch(t){}}}}function rs(t){return e=>{const n=t({...e,createStore:ns});Ee.addEventListener("online",(async t=>{await n.flush()}));return n}}function os(t=cn){return rs(ee(t))}const ss=1e6;const as=String(0);const is="main";const cs=Ee.navigator;let us="";let ls="";let fs="";let ps=cs?.userAgent||"";let ds="";const ms=cs?.language||cs?.languages?.[0]||"";function gs(t){return typeof t==="object"&&t!==null&&"getHighEntropyValues"in t}const hs=cs?.userAgentData;gs(hs)&&hs.getHighEntropyValues(["architecture","model","platform","platformVersion","fullVersionList"]).then((t=>{us=t.platform||"";fs=t.architecture||"";ds=t.model||"";ls=t.platformVersion||"";if(t.fullVersionList?.length){const e=t.fullVersionList[t.fullVersionList.length-1];ps=`${e.brand} ${e.version}`}})).catch((t=>{}));function ys(t){return!("thread_metadata"in t)}function vs(t){return ys(t)?xs(t):t}function _s(t){const e=t.contexts?.trace?.trace_id;typeof e==="string"&&e.length!==32&&Nn&&B.log(`[Profiling] Invalid traceId: ${e} on profiled event`);return typeof e!=="string"?"":e}
/**
 * Creates a profiling event envelope from a Sentry event. If profile does not pass
 * validation, returns null.
 * @param event
 * @param dsn
 * @param metadata
 * @param tunnel
 * @returns {EventEnvelope | null}
 */function bs(t,e,n,r){if(r.type!=="transaction")throw new TypeError("Profiling events may only be attached to transactions, this should never occur.");if(n===void 0||n===null)throw new TypeError(`Cannot construct profiling event envelope without a valid profile. Got ${n} instead.`);const o=_s(r);const s=vs(n);const a=e||(typeof r.start_timestamp==="number"?r.start_timestamp*1e3:ne()*1e3);const i=typeof r.timestamp==="number"?r.timestamp*1e3:ne()*1e3;const c={event_id:t,timestamp:new Date(a).toISOString(),platform:"javascript",version:"1",release:r.release||"",environment:r.environment||oe,runtime:{name:"javascript",version:Ee.navigator.userAgent},os:{name:us,version:ls,build_number:ps},device:{locale:ms,model:ds,manufacturer:ps,architecture:fs,is_emulator:false},debug_meta:{images:ws(n.resources)},profile:s,transactions:[{name:r.transaction||"",id:r.event_id||re(),trace_id:o,active_thread_id:as,relative_start_ns:"0",relative_end_ns:(1e6*(i-a)).toFixed(0)}]};return c}function Ss(t){return Tt(t).op==="pageload"}function xs(t){let e;let n=0;const r={samples:[],stacks:[],frames:[],thread_metadata:{[as]:{name:is}}};const o=t.samples[0];if(!o)return r;const s=o.timestamp;const a=Ct();const i=typeof performance.timeOrigin==="number"?performance.timeOrigin:a||0;const c=i-(a||i);t.samples.forEach(((o,a)=>{if(o.stackId===void 0){if(e===void 0){e=n;r.stacks[e]=[];n++}r.samples[a]={elapsed_since_start_ns:((o.timestamp+c-s)*ss).toFixed(0),stack_id:e,thread_id:as};return}let i=t.stacks[o.stackId];const u=[];while(i){u.push(i.frameId);const e=t.frames[i.frameId];e&&r.frames[i.frameId]===void 0&&(r.frames[i.frameId]={function:e.name,abs_path:typeof e.resourceId==="number"?t.resources[e.resourceId]:void 0,lineno:e.line,colno:e.column});i=i.parentId===void 0?void 0:t.stacks[i.parentId]}const l={elapsed_since_start_ns:((o.timestamp+c-s)*ss).toFixed(0),stack_id:n,thread_id:as};r.stacks[n]=u;r.samples[a]=l;n++}));return r}
/**
 * Adds items to envelope if they are not already present - mutates the envelope.
 * @param envelope
 */function Ts(t,e){if(!e.length)return t;for(const n of e)t[1].push([{type:"profile"},n]);return t}
/**
 * Finds transactions with profile_id context in the envelope
 * @param envelope
 * @returns
 */function Es(t){const e=[];se(t,((t,n)=>{if(n==="transaction")for(let n=1;n<t.length;n++){const r=t[n];r?.contexts&&r.contexts.profile&&r.contexts.profile.profile_id&&e.push(t[n])}}));return e}function ws(t){const e=f();const n=e?.getOptions();const r=n?.stackParser;return r?ae(r,t):[]}function ks(t){if(typeof t!=="number"&&typeof t!=="boolean"||typeof t==="number"&&isNaN(t)){Nn&&B.warn(`[Profiling] Invalid sample rate. Sample rate must be a boolean or a number between 0 and 1. Got ${JSON.stringify(t)} of type ${JSON.stringify(typeof t)}.`);return false}if(t===true||t===false)return true;if(t<0||t>1){Nn&&B.warn(`[Profiling] Invalid sample rate. Sample rate must be between 0 and 1. Got ${t}.`);return false}return true}function Is(t){if(t.samples.length<2){Nn&&B.log("[Profiling] Discarding profile because it contains less than 2 samples");return false}if(!t.frames.length){Nn&&B.log("[Profiling] Discarding profile because it contains no frames");return false}return true}let Ps=false;const Rs=3e4;
/**
 * Check if profiler constructor is available.
 * @param maybeProfiler
 */function Cs(t){return typeof t==="function"}function Os(){const t=Ee.Profiler;if(!Cs(t)){Nn&&B.log("[Profiling] Profiling is not supported by this browser, Profiler interface missing on window object.");return}const e=10;const n=Math.floor(Rs/e);try{return new t({sampleInterval:e,maxBufferSize:n})}catch(t){if(Nn){B.log("[Profiling] Failed to initialize the Profiling constructor, this is likely due to a missing 'Document-Policy': 'js-profiling' header.");B.log("[Profiling] Disabling profiling for current user session.")}Ps=true}}function qs(t){if(Ps){Nn&&B.log("[Profiling] Profiling has been disabled for the duration of the current user session.");return false}if(!t.isRecording()){Nn&&B.log("[Profiling] Discarding profile because transaction was not sampled.");return false}const e=f();const n=e?.getOptions();if(!n){Nn&&B.log("[Profiling] Profiling disabled, no options found.");return false}const r=n.profilesSampleRate;if(!ks(r)){Nn&&B.warn("[Profiling] Discarding profile because of invalid sample rate.");return false}if(!r){Nn&&B.log("[Profiling] Discarding profile because a negative sampling decision was inherited or profileSampleRate is set to 0");return false}const o=r===true||Math.random()<r;if(!o){Nn&&B.log(`[Profiling] Discarding profile because it's not included in the random sample (sampling rate = ${Number(r)})`);return false}return true}
/**
 * Creates a profiling envelope item, if the profile does not pass validation, returns null.
 * @param event
 * @returns {Profile | null}
 */function Ls(t,e,n,r){return Is(n)?bs(t,e,n,r):null}const $s=new Map;function As(){return $s.size}function Ds(t){const e=$s.get(t);e&&$s.delete(t);return e}function Fs(t,e){$s.set(t,e);if($s.size>30){const t=$s.keys().next().value;$s.delete(t)}}function Ns(t){let e;Ss(t)&&(e=ne()*1e3);const n=Os();if(!n)return;Nn&&B.log(`[Profiling] started profiling span: ${Tt(t).description}`);const r=re();mt().setContext("profile",{profile_id:r,start_timestamp:e});async function o(){if(t&&n)return n.stop().then((e=>{if(s){Ee.clearTimeout(s);s=void 0}Nn&&B.log(`[Profiling] stopped profiling of span: ${Tt(t).description}`);e?Fs(r,e):Nn&&B.log(`[Profiling] profiler returned null profile for: ${Tt(t).description}`,"this may indicate an overlapping span or a call to stopProfiling with a profile title that was never started")})).catch((t=>{Nn&&B.log("[Profiling] error while stopping profiler:",t)}))}let s=Ee.setTimeout((()=>{Nn&&B.log("[Profiling] max profile duration elapsed, stopping profiling for:",Tt(t).description);o()}),Rs);const a=t.end.bind(t);function i(){if(!t)return a();void o().then((()=>{a()}),(()=>{a()}));return t}t.end=i}const Hs="BrowserProfiling";const Ms=()=>({name:Hs,setup(t){const e=Lt();const n=e&&Nt(e);n&&Ss(n)&&qs(n)&&Ns(n);t.on("spanStart",(t=>{t===Nt(t)&&qs(t)&&Ns(t)}));t.on("beforeEnvelope",(t=>{if(!As())return;const e=Es(t);if(!e.length)return;const n=[];for(const t of e){const e=t?.contexts;const r=e?.profile?.profile_id;const o=e?.profile?.start_timestamp;if(typeof r!=="string"){Nn&&B.log("[Profiling] cannot find profile for a span without a profile context");continue}if(!r){Nn&&B.log("[Profiling] cannot find profile for a span without a profile context");continue}e?.profile&&delete e.profile;const s=Ds(r);if(!s){Nn&&B.log(`[Profiling] Could not retrieve profile for span: ${r}`);continue}const a=Ls(r,o,s,t);a&&n.push(a)}Ts(t,n)}))}});const js=H(Ms);const Bs="SpotlightBrowser";const Us=(t={})=>{const e=t.sidecarUrl||"http://localhost:8969/stream";return{name:Bs,setup:()=>{Nn&&B.log("Using Sidecar URL",e)},processEvent:t=>Xs(t)?null:t,afterAllSetup:t=>{zs(t,e)}}};function zs(t,e){const n=ie("fetch");let r=0;t.on("beforeEnvelope",(t=>{r>3?B.warn("[Spotlight] Disabled Sentry -> Spotlight integration due to too many failed requests:",r):n(e,{method:"POST",body:te(t),headers:{"Content-Type":"application/x-sentry-envelope"},mode:"cors"}).then((t=>{t.status>=200&&t.status<400&&(r=0)}),(t=>{r++;B.error("Sentry SDK can't connect to Sidecar is it running? See: https://spotlightjs.com/sidecar/npx/",t)}))}))}const Ws=H(Us);function Xs(t){return Boolean(t.type==="transaction"&&t.spans&&t.contexts&&t.contexts.trace&&t.contexts.trace.op==="ui.action.click"&&t.spans.some((({description:t})=>t?.includes("#sentry-spotlight"))))}const Gs=100;function Ys(t){const e=mt();const n=e.getScopeData().contexts.flags;const r=n?n.values:[];if(!r.length)return t;t.contexts===void 0&&(t.contexts={});t.contexts.flags={values:[...r]};return t}
/**
 * Creates a feature flags values array in current context if it does not exist
 * and inserts the flag into a FeatureFlag array while maintaining ordered LRU
 * properties. Not thread-safe. After inserting:
 * - `flags` is sorted in order of recency, with the newest flag at the end.
 * - No other flags with the same name exist in `flags`.
 * - The length of `flags` does not exceed `maxSize`. The oldest flag is evicted
 *  as needed.
 *
 * @param name     Name of the feature flag to insert.
 * @param value    Value of the feature flag.
 * @param maxSize  Max number of flags the buffer should store. It's recommended
 *   to keep this consistent across insertions. Default is FLAG_BUFFER_SIZE
 */function Vs(t,e,n=Gs){const r=mt().getScopeData().contexts;r.flags||(r.flags={values:[]});const o=r.flags.values;Ks(o,t,e,n)}function Ks(t,e,n,r){if(typeof n!=="boolean")return;if(t.length>r){Nn&&B.error(`[Feature Flags] insertToFlagBuffer called on a buffer larger than maxSize=${r}`);return}const o=t.findIndex((t=>t.flag===e));o!==-1&&t.splice(o,1);t.length===r&&t.shift();t.push({flag:e,result:n})}const Js=H((()=>({name:"FeatureFlags",processEvent(t,e,n){return Ys(t)},addFeatureFlag(t,e){Vs(t,e)}})));const Qs=H((()=>({name:"LaunchDarkly",processEvent(t,e,n){return Ys(t)}})));function Zs(){return{name:"sentry-flag-auditor",type:"flag-used",synchronous:true,method:(t,e,n)=>{Vs(t,e.value)}}}const ta=H((()=>({name:"OpenFeature",processEvent(t,e,n){return Ys(t)}})));class OpenFeatureIntegrationHook{after(t,e){Vs(e.flagKey,e.value)}error(t,e,n){Vs(t.flagKey,t.defaultValue)}}const ea=H((({featureFlagClientClass:t})=>({name:"Unleash",processEvent(t,e,n){return Ys(t)},setupOnce(){const e=t.prototype;V(e,"isEnabled",na)}})));
/**
 * Wraps the UnleashClient.isEnabled method to capture feature flag evaluations. Its only side effect is writing to Sentry scope.
 *
 * This wrapper is safe for all isEnabled signatures. If the signature does not match (this: UnleashClient, toggleName: string, ...args: unknown[]) => boolean,
 * we log an error and return the original result.
 *
 * @param original - The original method.
 * @returns Wrapped method. Results should match the original.
 */function na(t){return function(...e){const n=e[0];const r=t.apply(this,e);typeof n==="string"&&typeof r==="boolean"?Vs(n,r):Nn&&B.error(`[Feature Flags] UnleashClient.isEnabled does not match expected signature. arg0: ${n} (${typeof n}), result: ${r} (${typeof r})`);return r}}const ra=H((({featureFlagClient:t})=>({name:"Statsig",processEvent(t,e,n){return Ys(t)},setup(){t.on("gate_evaluation",(t=>{Vs(t.gate.name,t.gate.value)}))}})));async function oa(){const t=f();if(!t)return"no-client-active";if(!t.getDsn())return"no-dsn-configured";try{await fetch("https://o447951.ingest.sentry.io/api/1337/envelope/?sentry_version=7&sentry_key=1337&sentry_client=sentry.javascript.browser%2F1.33.7",{body:"{}",method:"POST",mode:"cors",credentials:"omit"})}catch{return"sentry-unreachable"}}export{BrowserClient,OpenFeatureIntegrationHook,Ee as WINDOW,Bn as breadcrumbsIntegration,Zn as browserApiErrorsIntegration,js as browserProfilingIntegration,sr as browserSessionIntegration,Bo as browserTracingIntegration,Zs as buildLaunchDarklyFlagUsedHandler,_n as chromeStackLineParser,ro as contextLinesIntegration,Dn as createUserFeedbackEnvelope,vo as defaultRequestInstrumentationOptions,Ln as defaultStackLineParsers,$n as defaultStackParser,oa as diagnoseSdkConnectivity,Ze as eventFromException,tn as eventFromMessage,Ue as exceptionFromError,Js as featureFlagsIntegration,Le as feedbackAsyncIntegration,$e as feedbackIntegration,$e as feedbackSyncIntegration,Pr as forceLoad,Tn as geckoStackLineParser,xr as getDefaultIntegrations,cr as globalHandlersIntegration,go as graphqlClientIntegration,Fr as httpClientIntegration,hr as httpContextIntegration,kr as init,_o as instrumentOutgoingRequests,Qs as launchDarklyIntegration,Oe as lazyLoadIntegration,Sr as linkedErrorsIntegration,Be as logger,os as makeBrowserOfflineTransport,cn as makeFetchTransport,Rr as onLoad,ta as openFeatureIntegration,Rn as opera10StackLineParser,qn as opera11StackLineParser,$r as reportingObserverIntegration,Ir as showReportDialog,Ws as spotlightBrowserIntegration,zo as startBrowserTracingNavigationSpan,Uo as startBrowserTracingPageLoadSpan,ra as statsigIntegration,ea as unleashIntegration,kn as winjsStackLineParser};

