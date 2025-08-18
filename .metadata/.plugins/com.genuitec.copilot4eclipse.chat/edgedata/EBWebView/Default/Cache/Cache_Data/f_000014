/* PrismJS 1.29.0
https://prismjs.com/download.html#themes=prism-okaidia&languages=markup+css+clike+javascript+abap+ada+arduino+asciidoc+aspnet+awk+bash+basic+batch+bison+bnf+c+csharp+cpp+clojure+cmake+cobol+coffeescript+css-extras+d+dart+diff+docker+dot+editorconfig+eiffel+elixir+elm+erlang+fortran+ftl+go+go-module+gradle+graphql+groovy+haml+handlebars+haskell+icon+ignore+java+javadoc+javadoclike+javastacktrace+jq+jsdoc+js-extras+json+json5+jsonp+jsstacktrace+js-templates+julia+latex+less+lisp+makefile+markdown+markup-templating+matlab+mongodb+nginx+nix+pascal+perl+php+phpdoc+php-extras+plsql+powerquery+powershell+processing+prolog+properties+protobuf+pug+puppet+pure+purebasic+purescript+python+qml+qore+r+jsx+tsx+regex+ruby+rust+sas+sass+scss+scala+scheme+shell-session+smalltalk+smarty+sml+sql+swift+systemd+tcl+typescript+typoscript+unrealscript+velocity+vim+wasm+web-idl+wolfram+xml-doc+xquery+yaml&plugins=inline-color+toolbar+copy-to-clipboard+download-button+diff-highlight */
/// <reference lib="WebWorker"/>

var _self = (typeof window !== 'undefined')
	? window   // if in browser
	: (
		(typeof WorkerGlobalScope !== 'undefined' && self instanceof WorkerGlobalScope)
			? self // if in worker
			: {}   // if in node js
	);

/**
 * Prism: Lightweight, robust, elegant syntax highlighting
 *
 * @license MIT <https://opensource.org/licenses/MIT>
 * @author Lea Verou <https://lea.verou.me>
 * @namespace
 * @public
 */
var Prism = (function (_self) {

	// Private helper vars
	var lang = /(?:^|\s)lang(?:uage)?-([\w-]+)(?=\s|$)/i;
	var uniqueId = 0;

	// The grammar object for plaintext
	var plainTextGrammar = {};


	var _ = {
		/**
		 * By default, Prism will attempt to highlight all code elements (by calling {@link Prism.highlightAll}) on the
		 * current page after the page finished loading. This might be a problem if e.g. you wanted to asynchronously load
		 * additional languages or plugins yourself.
		 *
		 * By setting this value to `true`, Prism will not automatically highlight all code elements on the page.
		 *
		 * You obviously have to change this value before the automatic highlighting started. To do this, you can add an
		 * empty Prism object into the global scope before loading the Prism script like this:
		 *
		 * ```js
		 * window.Prism = window.Prism || {};
		 * Prism.manual = true;
		 * // add a new <script> to load Prism's script
		 * ```
		 *
		 * @default false
		 * @type {boolean}
		 * @memberof Prism
		 * @public
		 */
		manual: _self.Prism && _self.Prism.manual,
		/**
		 * By default, if Prism is in a web worker, it assumes that it is in a worker it created itself, so it uses
		 * `addEventListener` to communicate with its parent instance. However, if you're using Prism manually in your
		 * own worker, you don't want it to do this.
		 *
		 * By setting this value to `true`, Prism will not add its own listeners to the worker.
		 *
		 * You obviously have to change this value before Prism executes. To do this, you can add an
		 * empty Prism object into the global scope before loading the Prism script like this:
		 *
		 * ```js
		 * window.Prism = window.Prism || {};
		 * Prism.disableWorkerMessageHandler = true;
		 * // Load Prism's script
		 * ```
		 *
		 * @default false
		 * @type {boolean}
		 * @memberof Prism
		 * @public
		 */
		disableWorkerMessageHandler: _self.Prism && _self.Prism.disableWorkerMessageHandler,

		/**
		 * A namespace for utility methods.
		 *
		 * All function in this namespace that are not explicitly marked as _public_ are for __internal use only__ and may
		 * change or disappear at any time.
		 *
		 * @namespace
		 * @memberof Prism
		 */
		util: {
			encode: function encode(tokens) {
				if (tokens instanceof Token) {
					return new Token(tokens.type, encode(tokens.content), tokens.alias);
				} else if (Array.isArray(tokens)) {
					return tokens.map(encode);
				} else {
					return tokens.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/\u00a0/g, ' ');
				}
			},

			/**
			 * Returns the name of the type of the given value.
			 *
			 * @param {any} o
			 * @returns {string}
			 * @example
			 * type(null)      === 'Null'
			 * type(undefined) === 'Undefined'
			 * type(123)       === 'Number'
			 * type('foo')     === 'String'
			 * type(true)      === 'Boolean'
			 * type([1, 2])    === 'Array'
			 * type({})        === 'Object'
			 * type(String)    === 'Function'
			 * type(/abc+/)    === 'RegExp'
			 */
			type: function (o) {
				return Object.prototype.toString.call(o).slice(8, -1);
			},

			/**
			 * Returns a unique number for the given object. Later calls will still return the same number.
			 *
			 * @param {Object} obj
			 * @returns {number}
			 */
			objId: function (obj) {
				if (!obj['__id']) {
					Object.defineProperty(obj, '__id', { value: ++uniqueId });
				}
				return obj['__id'];
			},

			/**
			 * Creates a deep clone of the given object.
			 *
			 * The main intended use of this function is to clone language definitions.
			 *
			 * @param {T} o
			 * @param {Record<number, any>} [visited]
			 * @returns {T}
			 * @template T
			 */
			clone: function deepClone(o, visited) {
				visited = visited || {};

				var clone; var id;
				switch (_.util.type(o)) {
					case 'Object':
						id = _.util.objId(o);
						if (visited[id]) {
							return visited[id];
						}
						clone = /** @type {Record<string, any>} */ ({});
						visited[id] = clone;

						for (var key in o) {
							if (o.hasOwnProperty(key)) {
								clone[key] = deepClone(o[key], visited);
							}
						}

						return /** @type {any} */ (clone);

					case 'Array':
						id = _.util.objId(o);
						if (visited[id]) {
							return visited[id];
						}
						clone = [];
						visited[id] = clone;

						(/** @type {Array} */(/** @type {any} */(o))).forEach(function (v, i) {
							clone[i] = deepClone(v, visited);
						});

						return /** @type {any} */ (clone);

					default:
						return o;
				}
			},

			/**
			 * Returns the Prism language of the given element set by a `language-xxxx` or `lang-xxxx` class.
			 *
			 * If no language is set for the element or the element is `null` or `undefined`, `none` will be returned.
			 *
			 * @param {Element} element
			 * @returns {string}
			 */
			getLanguage: function (element) {
				while (element) {
					var m = lang.exec(element.className);
					if (m) {
						return m[1].toLowerCase();
					}
					element = element.parentElement;
				}
				return 'none';
			},

			/**
			 * Sets the Prism `language-xxxx` class of the given element.
			 *
			 * @param {Element} element
			 * @param {string} language
			 * @returns {void}
			 */
			setLanguage: function (element, language) {
				// remove all `language-xxxx` classes
				// (this might leave behind a leading space)
				element.className = element.className.replace(RegExp(lang, 'gi'), '');

				// add the new `language-xxxx` class
				// (using `classList` will automatically clean up spaces for us)
				element.classList.add('language-' + language);
			},

			/**
			 * Returns the script element that is currently executing.
			 *
			 * This does __not__ work for line script element.
			 *
			 * @returns {HTMLScriptElement | null}
			 */
			currentScript: function () {
				if (typeof document === 'undefined') {
					return null;
				}
				if ('currentScript' in document && 1 < 2 /* hack to trip TS' flow analysis */) {
					return /** @type {any} */ (document.currentScript);
				}

				// IE11 workaround
				// we'll get the src of the current script by parsing IE11's error stack trace
				// this will not work for inline scripts

				try {
					throw new Error();
				} catch (err) {
					// Get file src url from stack. Specifically works with the format of stack traces in IE.
					// A stack will look like this:
					//
					// Error
					//    at _.util.currentScript (http://localhost/components/prism-core.js:119:5)
					//    at Global code (http://localhost/components/prism-core.js:606:1)

					var src = (/at [^(\r\n]*\((.*):[^:]+:[^:]+\)$/i.exec(err.stack) || [])[1];
					if (src) {
						var scripts = document.getElementsByTagName('script');
						for (var i in scripts) {
							if (scripts[i].src == src) {
								return scripts[i];
							}
						}
					}
					return null;
				}
			},

			/**
			 * Returns whether a given class is active for `element`.
			 *
			 * The class can be activated if `element` or one of its ancestors has the given class and it can be deactivated
			 * if `element` or one of its ancestors has the negated version of the given class. The _negated version_ of the
			 * given class is just the given class with a `no-` prefix.
			 *
			 * Whether the class is active is determined by the closest ancestor of `element` (where `element` itself is
			 * closest ancestor) that has the given class or the negated version of it. If neither `element` nor any of its
			 * ancestors have the given class or the negated version of it, then the default activation will be returned.
			 *
			 * In the paradoxical situation where the closest ancestor contains __both__ the given class and the negated
			 * version of it, the class is considered active.
			 *
			 * @param {Element} element
			 * @param {string} className
			 * @param {boolean} [defaultActivation=false]
			 * @returns {boolean}
			 */
			isActive: function (element, className, defaultActivation) {
				var no = 'no-' + className;

				while (element) {
					var classList = element.classList;
					if (classList.contains(className)) {
						return true;
					}
					if (classList.contains(no)) {
						return false;
					}
					element = element.parentElement;
				}
				return !!defaultActivation;
			}
		},

		/**
		 * This namespace contains all currently loaded languages and the some helper functions to create and modify languages.
		 *
		 * @namespace
		 * @memberof Prism
		 * @public
		 */
		languages: {
			/**
			 * The grammar for plain, unformatted text.
			 */
			plain: plainTextGrammar,
			plaintext: plainTextGrammar,
			text: plainTextGrammar,
			txt: plainTextGrammar,

			/**
			 * Creates a deep copy of the language with the given id and appends the given tokens.
			 *
			 * If a token in `redef` also appears in the copied language, then the existing token in the copied language
			 * will be overwritten at its original position.
			 *
			 * ## Best practices
			 *
			 * Since the position of overwriting tokens (token in `redef` that overwrite tokens in the copied language)
			 * doesn't matter, they can technically be in any order. However, this can be confusing to others that trying to
			 * understand the language definition because, normally, the order of tokens matters in Prism grammars.
			 *
			 * Therefore, it is encouraged to order overwriting tokens according to the positions of the overwritten tokens.
			 * Furthermore, all non-overwriting tokens should be placed after the overwriting ones.
			 *
			 * @param {string} id The id of the language to extend. This has to be a key in `Prism.languages`.
			 * @param {Grammar} redef The new tokens to append.
			 * @returns {Grammar} The new language created.
			 * @public
			 * @example
			 * Prism.languages['css-with-colors'] = Prism.languages.extend('css', {
			 *     // Prism.languages.css already has a 'comment' token, so this token will overwrite CSS' 'comment' token
			 *     // at its original position
			 *     'comment': { ... },
			 *     // CSS doesn't have a 'color' token, so this token will be appended
			 *     'color': /\b(?:red|green|blue)\b/
			 * });
			 */
			extend: function (id, redef) {
				var lang = _.util.clone(_.languages[id]);

				for (var key in redef) {
					lang[key] = redef[key];
				}

				return lang;
			},

			/**
			 * Inserts tokens _before_ another token in a language definition or any other grammar.
			 *
			 * ## Usage
			 *
			 * This helper method makes it easy to modify existing languages. For example, the CSS language definition
			 * not only defines CSS highlighting for CSS documents, but also needs to define highlighting for CSS embedded
			 * in HTML through `<style>` elements. To do this, it needs to modify `Prism.languages.markup` and add the
			 * appropriate tokens. However, `Prism.languages.markup` is a regular JavaScript object literal, so if you do
			 * this:
			 *
			 * ```js
			 * Prism.languages.markup.style = {
			 *     // token
			 * };
			 * ```
			 *
			 * then the `style` token will be added (and processed) at the end. `insertBefore` allows you to insert tokens
			 * before existing tokens. For the CSS example above, you would use it like this:
			 *
			 * ```js
			 * Prism.languages.insertBefore('markup', 'cdata', {
			 *     'style': {
			 *         // token
			 *     }
			 * });
			 * ```
			 *
			 * ## Special cases
			 *
			 * If the grammars of `inside` and `insert` have tokens with the same name, the tokens in `inside`'s grammar
			 * will be ignored.
			 *
			 * This behavior can be used to insert tokens after `before`:
			 *
			 * ```js
			 * Prism.languages.insertBefore('markup', 'comment', {
			 *     'comment': Prism.languages.markup.comment,
			 *     // tokens after 'comment'
			 * });
			 * ```
			 *
			 * ## Limitations
			 *
			 * The main problem `insertBefore` has to solve is iteration order. Since ES2015, the iteration order for object
			 * properties is guaranteed to be the insertion order (except for integer keys) but some browsers behave
			 * differently when keys are deleted and re-inserted. So `insertBefore` can't be implemented by temporarily
			 * deleting properties which is necessary to insert at arbitrary positions.
			 *
			 * To solve this problem, `insertBefore` doesn't actually insert the given tokens into the target object.
			 * Instead, it will create a new object and replace all references to the target object with the new one. This
			 * can be done without temporarily deleting properties, so the iteration order is well-defined.
			 *
			 * However, only references that can be reached from `Prism.languages` or `insert` will be replaced. I.e. if
			 * you hold the target object in a variable, then the value of the variable will not change.
			 *
			 * ```js
			 * var oldMarkup = Prism.languages.markup;
			 * var newMarkup = Prism.languages.insertBefore('markup', 'comment', { ... });
			 *
			 * assert(oldMarkup !== Prism.languages.markup);
			 * assert(newMarkup === Prism.languages.markup);
			 * ```
			 *
			 * @param {string} inside The property of `root` (e.g. a language id in `Prism.languages`) that contains the
			 * object to be modified.
			 * @param {string} before The key to insert before.
			 * @param {Grammar} insert An object containing the key-value pairs to be inserted.
			 * @param {Object<string, any>} [root] The object containing `inside`, i.e. the object that contains the
			 * object to be modified.
			 *
			 * Defaults to `Prism.languages`.
			 * @returns {Grammar} The new grammar object.
			 * @public
			 */
			insertBefore: function (inside, before, insert, root) {
				root = root || /** @type {any} */ (_.languages);
				var grammar = root[inside];
				/** @type {Grammar} */
				var ret = {};

				for (var token in grammar) {
					if (grammar.hasOwnProperty(token)) {

						if (token == before) {
							for (var newToken in insert) {
								if (insert.hasOwnProperty(newToken)) {
									ret[newToken] = insert[newToken];
								}
							}
						}

						// Do not insert token which also occur in insert. See #1525
						if (!insert.hasOwnProperty(token)) {
							ret[token] = grammar[token];
						}
					}
				}

				var old = root[inside];
				root[inside] = ret;

				// Update references in other language definitions
				_.languages.DFS(_.languages, function (key, value) {
					if (value === old && key != inside) {
						this[key] = ret;
					}
				});

				return ret;
			},

			// Traverse a language definition with Depth First Search
			DFS: function DFS(o, callback, type, visited) {
				visited = visited || {};

				var objId = _.util.objId;

				for (var i in o) {
					if (o.hasOwnProperty(i)) {
						callback.call(o, i, o[i], type || i);

						var property = o[i];
						var propertyType = _.util.type(property);

						if (propertyType === 'Object' && !visited[objId(property)]) {
							visited[objId(property)] = true;
							DFS(property, callback, null, visited);
						} else if (propertyType === 'Array' && !visited[objId(property)]) {
							visited[objId(property)] = true;
							DFS(property, callback, i, visited);
						}
					}
				}
			}
		},

		plugins: {},

		/**
		 * This is the most high-level function in Prism’s API.
		 * It fetches all the elements that have a `.language-xxxx` class and then calls {@link Prism.highlightElement} on
		 * each one of them.
		 *
		 * This is equivalent to `Prism.highlightAllUnder(document, async, callback)`.
		 *
		 * @param {boolean} [async=false] Same as in {@link Prism.highlightAllUnder}.
		 * @param {HighlightCallback} [callback] Same as in {@link Prism.highlightAllUnder}.
		 * @memberof Prism
		 * @public
		 */
		highlightAll: function (async, callback) {
			_.highlightAllUnder(document, async, callback);
		},

		/**
		 * Fetches all the descendants of `container` that have a `.language-xxxx` class and then calls
		 * {@link Prism.highlightElement} on each one of them.
		 *
		 * The following hooks will be run:
		 * 1. `before-highlightall`
		 * 2. `before-all-elements-highlight`
		 * 3. All hooks of {@link Prism.highlightElement} for each element.
		 *
		 * @param {ParentNode} container The root element, whose descendants that have a `.language-xxxx` class will be highlighted.
		 * @param {boolean} [async=false] Whether each element is to be highlighted asynchronously using Web Workers.
		 * @param {HighlightCallback} [callback] An optional callback to be invoked on each element after its highlighting is done.
		 * @memberof Prism
		 * @public
		 */
		highlightAllUnder: function (container, async, callback) {
			var env = {
				callback: callback,
				container: container,
				selector: 'code[class*="language-"], [class*="language-"] code, code[class*="lang-"], [class*="lang-"] code'
			};

			_.hooks.run('before-highlightall', env);

			env.elements = Array.prototype.slice.apply(env.container.querySelectorAll(env.selector));

			_.hooks.run('before-all-elements-highlight', env);

			for (var i = 0, element; (element = env.elements[i++]);) {
				_.highlightElement(element, async === true, env.callback);
			}
		},

		/**
		 * Highlights the code inside a single element.
		 *
		 * The following hooks will be run:
		 * 1. `before-sanity-check`
		 * 2. `before-highlight`
		 * 3. All hooks of {@link Prism.highlight}. These hooks will be run by an asynchronous worker if `async` is `true`.
		 * 4. `before-insert`
		 * 5. `after-highlight`
		 * 6. `complete`
		 *
		 * Some the above hooks will be skipped if the element doesn't contain any text or there is no grammar loaded for
		 * the element's language.
		 *
		 * @param {Element} element The element containing the code.
		 * It must have a class of `language-xxxx` to be processed, where `xxxx` is a valid language identifier.
		 * @param {boolean} [async=false] Whether the element is to be highlighted asynchronously using Web Workers
		 * to improve performance and avoid blocking the UI when highlighting very large chunks of code. This option is
		 * [disabled by default](https://prismjs.com/faq.html#why-is-asynchronous-highlighting-disabled-by-default).
		 *
		 * Note: All language definitions required to highlight the code must be included in the main `prism.js` file for
		 * asynchronous highlighting to work. You can build your own bundle on the
		 * [Download page](https://prismjs.com/download.html).
		 * @param {HighlightCallback} [callback] An optional callback to be invoked after the highlighting is done.
		 * Mostly useful when `async` is `true`, since in that case, the highlighting is done asynchronously.
		 * @memberof Prism
		 * @public
		 */
		highlightElement: function (element, async, callback) {
			// Find language
			var language = _.util.getLanguage(element);
			var grammar = _.languages[language];

			// Set language on the element, if not present
			_.util.setLanguage(element, language);

			// Set language on the parent, for styling
			var parent = element.parentElement;
			if (parent && parent.nodeName.toLowerCase() === 'pre') {
				_.util.setLanguage(parent, language);
			}

			var code = element.textContent;

			var env = {
				element: element,
				language: language,
				grammar: grammar,
				code: code
			};

			function insertHighlightedCode(highlightedCode) {
				env.highlightedCode = highlightedCode;

				_.hooks.run('before-insert', env);

				env.element.innerHTML = env.highlightedCode;

				_.hooks.run('after-highlight', env);
				_.hooks.run('complete', env);
				callback && callback.call(env.element);
			}

			_.hooks.run('before-sanity-check', env);

			// plugins may change/add the parent/element
			parent = env.element.parentElement;
			if (parent && parent.nodeName.toLowerCase() === 'pre' && !parent.hasAttribute('tabindex')) {
				parent.setAttribute('tabindex', '0');
			}

			if (!env.code) {
				_.hooks.run('complete', env);
				callback && callback.call(env.element);
				return;
			}

			_.hooks.run('before-highlight', env);

			if (!env.grammar) {
				insertHighlightedCode(_.util.encode(env.code));
				return;
			}

			if (async && _self.Worker) {
				var worker = new Worker(_.filename);

				worker.onmessage = function (evt) {
					insertHighlightedCode(evt.data);
				};

				worker.postMessage(JSON.stringify({
					language: env.language,
					code: env.code,
					immediateClose: true
				}));
			} else {
				insertHighlightedCode(_.highlight(env.code, env.grammar, env.language));
			}
		},

		/**
		 * Low-level function, only use if you know what you’re doing. It accepts a string of text as input
		 * and the language definitions to use, and returns a string with the HTML produced.
		 *
		 * The following hooks will be run:
		 * 1. `before-tokenize`
		 * 2. `after-tokenize`
		 * 3. `wrap`: On each {@link Token}.
		 *
		 * @param {string} text A string with the code to be highlighted.
		 * @param {Grammar} grammar An object containing the tokens to use.
		 *
		 * Usually a language definition like `Prism.languages.markup`.
		 * @param {string} language The name of the language definition passed to `grammar`.
		 * @returns {string} The highlighted HTML.
		 * @memberof Prism
		 * @public
		 * @example
		 * Prism.highlight('var foo = true;', Prism.languages.javascript, 'javascript');
		 */
		highlight: function (text, grammar, language) {
			var env = {
				code: text,
				grammar: grammar,
				language: language
			};
			_.hooks.run('before-tokenize', env);
			if (!env.grammar) {
				throw new Error('The language "' + env.language + '" has no grammar.');
			}
			env.tokens = _.tokenize(env.code, env.grammar);
			_.hooks.run('after-tokenize', env);
			return Token.stringify(_.util.encode(env.tokens), env.language);
		},

		/**
		 * This is the heart of Prism, and the most low-level function you can use. It accepts a string of text as input
		 * and the language definitions to use, and returns an array with the tokenized code.
		 *
		 * When the language definition includes nested tokens, the function is called recursively on each of these tokens.
		 *
		 * This method could be useful in other contexts as well, as a very crude parser.
		 *
		 * @param {string} text A string with the code to be highlighted.
		 * @param {Grammar} grammar An object containing the tokens to use.
		 *
		 * Usually a language definition like `Prism.languages.markup`.
		 * @returns {TokenStream} An array of strings and tokens, a token stream.
		 * @memberof Prism
		 * @public
		 * @example
		 * let code = `var foo = 0;`;
		 * let tokens = Prism.tokenize(code, Prism.languages.javascript);
		 * tokens.forEach(token => {
		 *     if (token instanceof Prism.Token && token.type === 'number') {
		 *         console.log(`Found numeric literal: ${token.content}`);
		 *     }
		 * });
		 */
		tokenize: function (text, grammar) {
			var rest = grammar.rest;
			if (rest) {
				for (var token in rest) {
					grammar[token] = rest[token];
				}

				delete grammar.rest;
			}

			var tokenList = new LinkedList();
			addAfter(tokenList, tokenList.head, text);

			matchGrammar(text, tokenList, grammar, tokenList.head, 0);

			return toArray(tokenList);
		},

		/**
		 * @namespace
		 * @memberof Prism
		 * @public
		 */
		hooks: {
			all: {},

			/**
			 * Adds the given callback to the list of callbacks for the given hook.
			 *
			 * The callback will be invoked when the hook it is registered for is run.
			 * Hooks are usually directly run by a highlight function but you can also run hooks yourself.
			 *
			 * One callback function can be registered to multiple hooks and the same hook multiple times.
			 *
			 * @param {string} name The name of the hook.
			 * @param {HookCallback} callback The callback function which is given environment variables.
			 * @public
			 */
			add: function (name, callback) {
				var hooks = _.hooks.all;

				hooks[name] = hooks[name] || [];

				hooks[name].push(callback);
			},

			/**
			 * Runs a hook invoking all registered callbacks with the given environment variables.
			 *
			 * Callbacks will be invoked synchronously and in the order in which they were registered.
			 *
			 * @param {string} name The name of the hook.
			 * @param {Object<string, any>} env The environment variables of the hook passed to all callbacks registered.
			 * @public
			 */
			run: function (name, env) {
				var callbacks = _.hooks.all[name];

				if (!callbacks || !callbacks.length) {
					return;
				}

				for (var i = 0, callback; (callback = callbacks[i++]);) {
					callback(env);
				}
			}
		},

		Token: Token
	};
	_self.Prism = _;


	// Typescript note:
	// The following can be used to import the Token type in JSDoc:
	//
	//   @typedef {InstanceType<import("./prism-core")["Token"]>} Token

	/**
	 * Creates a new token.
	 *
	 * @param {string} type See {@link Token#type type}
	 * @param {string | TokenStream} content See {@link Token#content content}
	 * @param {string|string[]} [alias] The alias(es) of the token.
	 * @param {string} [matchedStr=""] A copy of the full string this token was created from.
	 * @class
	 * @global
	 * @public
	 */
	function Token(type, content, alias, matchedStr) {
		/**
		 * The type of the token.
		 *
		 * This is usually the key of a pattern in a {@link Grammar}.
		 *
		 * @type {string}
		 * @see GrammarToken
		 * @public
		 */
		this.type = type;
		/**
		 * The strings or tokens contained by this token.
		 *
		 * This will be a token stream if the pattern matched also defined an `inside` grammar.
		 *
		 * @type {string | TokenStream}
		 * @public
		 */
		this.content = content;
		/**
		 * The alias(es) of the token.
		 *
		 * @type {string|string[]}
		 * @see GrammarToken
		 * @public
		 */
		this.alias = alias;
		// Copy of the full string this token was created from
		this.length = (matchedStr || '').length | 0;
	}

	/**
	 * A token stream is an array of strings and {@link Token Token} objects.
	 *
	 * Token streams have to fulfill a few properties that are assumed by most functions (mostly internal ones) that process
	 * them.
	 *
	 * 1. No adjacent strings.
	 * 2. No empty strings.
	 *
	 *    The only exception here is the token stream that only contains the empty string and nothing else.
	 *
	 * @typedef {Array<string | Token>} TokenStream
	 * @global
	 * @public
	 */

	/**
	 * Converts the given token or token stream to an HTML representation.
	 *
	 * The following hooks will be run:
	 * 1. `wrap`: On each {@link Token}.
	 *
	 * @param {string | Token | TokenStream} o The token or token stream to be converted.
	 * @param {string} language The name of current language.
	 * @returns {string} The HTML representation of the token or token stream.
	 * @memberof Token
	 * @static
	 */
	Token.stringify = function stringify(o, language) {
		if (typeof o == 'string') {
			return o;
		}
		if (Array.isArray(o)) {
			var s = '';
			o.forEach(function (e) {
				s += stringify(e, language);
			});
			return s;
		}

		var env = {
			type: o.type,
			content: stringify(o.content, language),
			tag: 'span',
			classes: ['token', o.type],
			attributes: {},
			language: language
		};

		var aliases = o.alias;
		if (aliases) {
			if (Array.isArray(aliases)) {
				Array.prototype.push.apply(env.classes, aliases);
			} else {
				env.classes.push(aliases);
			}
		}

		_.hooks.run('wrap', env);

		var attributes = '';
		for (var name in env.attributes) {
			attributes += ' ' + name + '="' + (env.attributes[name] || '').replace(/"/g, '&quot;') + '"';
		}

		return '<' + env.tag + ' class="' + env.classes.join(' ') + '"' + attributes + '>' + env.content + '</' + env.tag + '>';
	};

	/**
	 * @param {RegExp} pattern
	 * @param {number} pos
	 * @param {string} text
	 * @param {boolean} lookbehind
	 * @returns {RegExpExecArray | null}
	 */
	function matchPattern(pattern, pos, text, lookbehind) {
		pattern.lastIndex = pos;
		var match = pattern.exec(text);
		if (match && lookbehind && match[1]) {
			// change the match to remove the text matched by the Prism lookbehind group
			var lookbehindLength = match[1].length;
			match.index += lookbehindLength;
			match[0] = match[0].slice(lookbehindLength);
		}
		return match;
	}

	/**
	 * @param {string} text
	 * @param {LinkedList<string | Token>} tokenList
	 * @param {any} grammar
	 * @param {LinkedListNode<string | Token>} startNode
	 * @param {number} startPos
	 * @param {RematchOptions} [rematch]
	 * @returns {void}
	 * @private
	 *
	 * @typedef RematchOptions
	 * @property {string} cause
	 * @property {number} reach
	 */
	function matchGrammar(text, tokenList, grammar, startNode, startPos, rematch) {
		for (var token in grammar) {
			if (!grammar.hasOwnProperty(token) || !grammar[token]) {
				continue;
			}

			var patterns = grammar[token];
			patterns = Array.isArray(patterns) ? patterns : [patterns];

			for (var j = 0; j < patterns.length; ++j) {
				if (rematch && rematch.cause == token + ',' + j) {
					return;
				}

				var patternObj = patterns[j];
				var inside = patternObj.inside;
				var lookbehind = !!patternObj.lookbehind;
				var greedy = !!patternObj.greedy;
				var alias = patternObj.alias;

				if (greedy && !patternObj.pattern.global) {
					// Without the global flag, lastIndex won't work
					var flags = patternObj.pattern.toString().match(/[imsuy]*$/)[0];
					patternObj.pattern = RegExp(patternObj.pattern.source, flags + 'g');
				}

				/** @type {RegExp} */
				var pattern = patternObj.pattern || patternObj;

				for ( // iterate the token list and keep track of the current token/string position
					var currentNode = startNode.next, pos = startPos;
					currentNode !== tokenList.tail;
					pos += currentNode.value.length, currentNode = currentNode.next
				) {

					if (rematch && pos >= rematch.reach) {
						break;
					}

					var str = currentNode.value;

					if (tokenList.length > text.length) {
						// Something went terribly wrong, ABORT, ABORT!
						return;
					}

					if (str instanceof Token) {
						continue;
					}

					var removeCount = 1; // this is the to parameter of removeBetween
					var match;

					if (greedy) {
						match = matchPattern(pattern, pos, text, lookbehind);
						if (!match || match.index >= text.length) {
							break;
						}

						var from = match.index;
						var to = match.index + match[0].length;
						var p = pos;

						// find the node that contains the match
						p += currentNode.value.length;
						while (from >= p) {
							currentNode = currentNode.next;
							p += currentNode.value.length;
						}
						// adjust pos (and p)
						p -= currentNode.value.length;
						pos = p;

						// the current node is a Token, then the match starts inside another Token, which is invalid
						if (currentNode.value instanceof Token) {
							continue;
						}

						// find the last node which is affected by this match
						for (
							var k = currentNode;
							k !== tokenList.tail && (p < to || typeof k.value === 'string');
							k = k.next
						) {
							removeCount++;
							p += k.value.length;
						}
						removeCount--;

						// replace with the new match
						str = text.slice(pos, p);
						match.index -= pos;
					} else {
						match = matchPattern(pattern, 0, str, lookbehind);
						if (!match) {
							continue;
						}
					}

					// eslint-disable-next-line no-redeclare
					var from = match.index;
					var matchStr = match[0];
					var before = str.slice(0, from);
					var after = str.slice(from + matchStr.length);

					var reach = pos + str.length;
					if (rematch && reach > rematch.reach) {
						rematch.reach = reach;
					}

					var removeFrom = currentNode.prev;

					if (before) {
						removeFrom = addAfter(tokenList, removeFrom, before);
						pos += before.length;
					}

					removeRange(tokenList, removeFrom, removeCount);

					var wrapped = new Token(token, inside ? _.tokenize(matchStr, inside) : matchStr, alias, matchStr);
					currentNode = addAfter(tokenList, removeFrom, wrapped);

					if (after) {
						addAfter(tokenList, currentNode, after);
					}

					if (removeCount > 1) {
						// at least one Token object was removed, so we have to do some rematching
						// this can only happen if the current pattern is greedy

						/** @type {RematchOptions} */
						var nestedRematch = {
							cause: token + ',' + j,
							reach: reach
						};
						matchGrammar(text, tokenList, grammar, currentNode.prev, pos, nestedRematch);

						// the reach might have been extended because of the rematching
						if (rematch && nestedRematch.reach > rematch.reach) {
							rematch.reach = nestedRematch.reach;
						}
					}
				}
			}
		}
	}

	/**
	 * @typedef LinkedListNode
	 * @property {T} value
	 * @property {LinkedListNode<T> | null} prev The previous node.
	 * @property {LinkedListNode<T> | null} next The next node.
	 * @template T
	 * @private
	 */

	/**
	 * @template T
	 * @private
	 */
	function LinkedList() {
		/** @type {LinkedListNode<T>} */
		var head = { value: null, prev: null, next: null };
		/** @type {LinkedListNode<T>} */
		var tail = { value: null, prev: head, next: null };
		head.next = tail;

		/** @type {LinkedListNode<T>} */
		this.head = head;
		/** @type {LinkedListNode<T>} */
		this.tail = tail;
		this.length = 0;
	}

	/**
	 * Adds a new node with the given value to the list.
	 *
	 * @param {LinkedList<T>} list
	 * @param {LinkedListNode<T>} node
	 * @param {T} value
	 * @returns {LinkedListNode<T>} The added node.
	 * @template T
	 */
	function addAfter(list, node, value) {
		// assumes that node != list.tail && values.length >= 0
		var next = node.next;

		var newNode = { value: value, prev: node, next: next };
		node.next = newNode;
		next.prev = newNode;
		list.length++;

		return newNode;
	}
	/**
	 * Removes `count` nodes after the given node. The given node will not be removed.
	 *
	 * @param {LinkedList<T>} list
	 * @param {LinkedListNode<T>} node
	 * @param {number} count
	 * @template T
	 */
	function removeRange(list, node, count) {
		var next = node.next;
		for (var i = 0; i < count && next !== list.tail; i++) {
			next = next.next;
		}
		node.next = next;
		next.prev = node;
		list.length -= i;
	}
	/**
	 * @param {LinkedList<T>} list
	 * @returns {T[]}
	 * @template T
	 */
	function toArray(list) {
		var array = [];
		var node = list.head.next;
		while (node !== list.tail) {
			array.push(node.value);
			node = node.next;
		}
		return array;
	}


	if (!_self.document) {
		if (!_self.addEventListener) {
			// in Node.js
			return _;
		}

		if (!_.disableWorkerMessageHandler) {
			// In worker
			_self.addEventListener('message', function (evt) {
				var message = JSON.parse(evt.data);
				var lang = message.language;
				var code = message.code;
				var immediateClose = message.immediateClose;

				_self.postMessage(_.highlight(code, _.languages[lang], lang));
				if (immediateClose) {
					_self.close();
				}
			}, false);
		}

		return _;
	}

	// Get current script and highlight
	var script = _.util.currentScript();

	if (script) {
		_.filename = script.src;

		if (script.hasAttribute('data-manual')) {
			_.manual = true;
		}
	}

	function highlightAutomaticallyCallback() {
		if (!_.manual) {
			_.highlightAll();
		}
	}

	if (!_.manual) {
		// If the document state is "loading", then we'll use DOMContentLoaded.
		// If the document state is "interactive" and the prism.js script is deferred, then we'll also use the
		// DOMContentLoaded event because there might be some plugins or languages which have also been deferred and they
		// might take longer one animation frame to execute which can create a race condition where only some plugins have
		// been loaded when Prism.highlightAll() is executed, depending on how fast resources are loaded.
		// See https://github.com/PrismJS/prism/issues/2102
		var readyState = document.readyState;
		if (readyState === 'loading' || readyState === 'interactive' && script && script.defer) {
			document.addEventListener('DOMContentLoaded', highlightAutomaticallyCallback);
		} else {
			if (window.requestAnimationFrame) {
				window.requestAnimationFrame(highlightAutomaticallyCallback);
			} else {
				window.setTimeout(highlightAutomaticallyCallback, 16);
			}
		}
	}

	return _;

}(_self));

if (typeof module !== 'undefined' && module.exports) {
	module.exports = Prism;
}

// hack for components to work correctly in node.js
if (typeof global !== 'undefined') {
	global.Prism = Prism;
}

// some additional documentation/types

/**
 * The expansion of a simple `RegExp` literal to support additional properties.
 *
 * @typedef GrammarToken
 * @property {RegExp} pattern The regular expression of the token.
 * @property {boolean} [lookbehind=false] If `true`, then the first capturing group of `pattern` will (effectively)
 * behave as a lookbehind group meaning that the captured text will not be part of the matched text of the new token.
 * @property {boolean} [greedy=false] Whether the token is greedy.
 * @property {string|string[]} [alias] An optional alias or list of aliases.
 * @property {Grammar} [inside] The nested grammar of this token.
 *
 * The `inside` grammar will be used to tokenize the text value of each token of this kind.
 *
 * This can be used to make nested and even recursive language definitions.
 *
 * Note: This can cause infinite recursion. Be careful when you embed different languages or even the same language into
 * each another.
 * @global
 * @public
 */

/**
 * @typedef Grammar
 * @type {Object<string, RegExp | GrammarToken | Array<RegExp | GrammarToken>>}
 * @property {Grammar} [rest] An optional grammar object that will be appended to this grammar.
 * @global
 * @public
 */

/**
 * A function which will invoked after an element was successfully highlighted.
 *
 * @callback HighlightCallback
 * @param {Element} element The element successfully highlighted.
 * @returns {void}
 * @global
 * @public
 */

/**
 * @callback HookCallback
 * @param {Object<string, any>} env The environment variables of the hook.
 * @returns {void}
 * @global
 * @public
 */
;
Prism.languages.markup = {
	'comment': {
		pattern: /<!--(?:(?!<!--)[\s\S])*?-->/,
		greedy: true
	},
	'prolog': {
		pattern: /<\?[\s\S]+?\?>/,
		greedy: true
	},
	'doctype': {
		// https://www.w3.org/TR/xml/#NT-doctypedecl
		pattern: /<!DOCTYPE(?:[^>"'[\]]|"[^"]*"|'[^']*')+(?:\[(?:[^<"'\]]|"[^"]*"|'[^']*'|<(?!!--)|<!--(?:[^-]|-(?!->))*-->)*\]\s*)?>/i,
		greedy: true,
		inside: {
			'internal-subset': {
				pattern: /(^[^\[]*\[)[\s\S]+(?=\]>$)/,
				lookbehind: true,
				greedy: true,
				inside: null // see below
			},
			'string': {
				pattern: /"[^"]*"|'[^']*'/,
				greedy: true
			},
			'punctuation': /^<!|>$|[[\]]/,
			'doctype-tag': /^DOCTYPE/i,
			'name': /[^\s<>'"]+/
		}
	},
	'cdata': {
		pattern: /<!\[CDATA\[[\s\S]*?\]\]>/i,
		greedy: true
	},
	'tag': {
		pattern: /<\/?(?!\d)[^\s>\/=$<%]+(?:\s(?:\s*[^\s>\/=]+(?:\s*=\s*(?:"[^"]*"|'[^']*'|[^\s'">=]+(?=[\s>]))|(?=[\s/>])))+)?\s*\/?>/,
		greedy: true,
		inside: {
			'tag': {
				pattern: /^<\/?[^\s>\/]+/,
				inside: {
					'punctuation': /^<\/?/,
					'namespace': /^[^\s>\/:]+:/
				}
			},
			'special-attr': [],
			'attr-value': {
				pattern: /=\s*(?:"[^"]*"|'[^']*'|[^\s'">=]+)/,
				inside: {
					'punctuation': [
						{
							pattern: /^=/,
							alias: 'attr-equals'
						},
						{
							pattern: /^(\s*)["']|["']$/,
							lookbehind: true
						}
					]
				}
			},
			'punctuation': /\/?>/,
			'attr-name': {
				pattern: /[^\s>\/]+/,
				inside: {
					'namespace': /^[^\s>\/:]+:/
				}
			}

		}
	},
	'entity': [
		{
			pattern: /&[\da-z]{1,8};/i,
			alias: 'named-entity'
		},
		/&#x?[\da-f]{1,8};/i
	]
};

Prism.languages.markup['tag'].inside['attr-value'].inside['entity'] =
	Prism.languages.markup['entity'];
Prism.languages.markup['doctype'].inside['internal-subset'].inside = Prism.languages.markup;

// Plugin to make entity title show the real entity, idea by Roman Komarov
Prism.hooks.add('wrap', function (env) {

	if (env.type === 'entity') {
		env.attributes['title'] = env.content.replace(/&amp;/, '&');
	}
});

Object.defineProperty(Prism.languages.markup.tag, 'addInlined', {
	/**
	 * Adds an inlined language to markup.
	 *
	 * An example of an inlined language is CSS with `<style>` tags.
	 *
	 * @param {string} tagName The name of the tag that contains the inlined language. This name will be treated as
	 * case insensitive.
	 * @param {string} lang The language key.
	 * @example
	 * addInlined('style', 'css');
	 */
	value: function addInlined(tagName, lang) {
		var includedCdataInside = {};
		includedCdataInside['language-' + lang] = {
			pattern: /(^<!\[CDATA\[)[\s\S]+?(?=\]\]>$)/i,
			lookbehind: true,
			inside: Prism.languages[lang]
		};
		includedCdataInside['cdata'] = /^<!\[CDATA\[|\]\]>$/i;

		var inside = {
			'included-cdata': {
				pattern: /<!\[CDATA\[[\s\S]*?\]\]>/i,
				inside: includedCdataInside
			}
		};
		inside['language-' + lang] = {
			pattern: /[\s\S]+/,
			inside: Prism.languages[lang]
		};

		var def = {};
		def[tagName] = {
			pattern: RegExp(/(<__[^>]*>)(?:<!\[CDATA\[(?:[^\]]|\](?!\]>))*\]\]>|(?!<!\[CDATA\[)[\s\S])*?(?=<\/__>)/.source.replace(/__/g, function () { return tagName; }), 'i'),
			lookbehind: true,
			greedy: true,
			inside: inside
		};

		Prism.languages.insertBefore('markup', 'cdata', def);
	}
});
Object.defineProperty(Prism.languages.markup.tag, 'addAttribute', {
	/**
	 * Adds an pattern to highlight languages embedded in HTML attributes.
	 *
	 * An example of an inlined language is CSS with `style` attributes.
	 *
	 * @param {string} attrName The name of the tag that contains the inlined language. This name will be treated as
	 * case insensitive.
	 * @param {string} lang The language key.
	 * @example
	 * addAttribute('style', 'css');
	 */
	value: function (attrName, lang) {
		Prism.languages.markup.tag.inside['special-attr'].push({
			pattern: RegExp(
				/(^|["'\s])/.source + '(?:' + attrName + ')' + /\s*=\s*(?:"[^"]*"|'[^']*'|[^\s'">=]+(?=[\s>]))/.source,
				'i'
			),
			lookbehind: true,
			inside: {
				'attr-name': /^[^\s=]+/,
				'attr-value': {
					pattern: /=[\s\S]+/,
					inside: {
						'value': {
							pattern: /(^=\s*(["']|(?!["'])))\S[\s\S]*(?=\2$)/,
							lookbehind: true,
							alias: [lang, 'language-' + lang],
							inside: Prism.languages[lang]
						},
						'punctuation': [
							{
								pattern: /^=/,
								alias: 'attr-equals'
							},
							/"|'/
						]
					}
				}
			}
		});
	}
});

Prism.languages.html = Prism.languages.markup;
Prism.languages.mathml = Prism.languages.markup;
Prism.languages.svg = Prism.languages.markup;

Prism.languages.xml = Prism.languages.extend('markup', {});
Prism.languages.ssml = Prism.languages.xml;
Prism.languages.atom = Prism.languages.xml;
Prism.languages.rss = Prism.languages.xml;

(function (Prism) {

	var string = /(?:"(?:\\(?:\r\n|[\s\S])|[^"\\\r\n])*"|'(?:\\(?:\r\n|[\s\S])|[^'\\\r\n])*')/;

	Prism.languages.css = {
		'comment': /\/\*[\s\S]*?\*\//,
		'atrule': {
			pattern: RegExp('@[\\w-](?:' + /[^;{\s"']|\s+(?!\s)/.source + '|' + string.source + ')*?' + /(?:;|(?=\s*\{))/.source),
			inside: {
				'rule': /^@[\w-]+/,
				'selector-function-argument': {
					pattern: /(\bselector\s*\(\s*(?![\s)]))(?:[^()\s]|\s+(?![\s)])|\((?:[^()]|\([^()]*\))*\))+(?=\s*\))/,
					lookbehind: true,
					alias: 'selector'
				},
				'keyword': {
					pattern: /(^|[^\w-])(?:and|not|only|or)(?![\w-])/,
					lookbehind: true
				}
				// See rest below
			}
		},
		'url': {
			// https://drafts.csswg.org/css-values-3/#urls
			pattern: RegExp('\\burl\\((?:' + string.source + '|' + /(?:[^\\\r\n()"']|\\[\s\S])*/.source + ')\\)', 'i'),
			greedy: true,
			inside: {
				'function': /^url/i,
				'punctuation': /^\(|\)$/,
				'string': {
					pattern: RegExp('^' + string.source + '$'),
					alias: 'url'
				}
			}
		},
		'selector': {
			pattern: RegExp('(^|[{}\\s])[^{}\\s](?:[^{};"\'\\s]|\\s+(?![\\s{])|' + string.source + ')*(?=\\s*\\{)'),
			lookbehind: true
		},
		'string': {
			pattern: string,
			greedy: true
		},
		'property': {
			pattern: /(^|[^-\w\xA0-\uFFFF])(?!\s)[-_a-z\xA0-\uFFFF](?:(?!\s)[-\w\xA0-\uFFFF])*(?=\s*:)/i,
			lookbehind: true
		},
		'important': /!important\b/i,
		'function': {
			pattern: /(^|[^-a-z0-9])[-a-z0-9]+(?=\()/i,
			lookbehind: true
		},
		'punctuation': /[(){};:,]/
	};

	Prism.languages.css['atrule'].inside.rest = Prism.languages.css;

	var markup = Prism.languages.markup;
	if (markup) {
		markup.tag.addInlined('style', 'css');
		markup.tag.addAttribute('style', 'css');
	}

}(Prism));

Prism.languages.clike = {
	'comment': [
		{
			pattern: /(^|[^\\])\/\*[\s\S]*?(?:\*\/|$)/,
			lookbehind: true,
			greedy: true
		},
		{
			pattern: /(^|[^\\:])\/\/.*/,
			lookbehind: true,
			greedy: true
		}
	],
	'string': {
		pattern: /(["'])(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1/,
		greedy: true
	},
	'class-name': {
		pattern: /(\b(?:class|extends|implements|instanceof|interface|new|trait)\s+|\bcatch\s+\()[\w.\\]+/i,
		lookbehind: true,
		inside: {
			'punctuation': /[.\\]/
		}
	},
	'keyword': /\b(?:break|catch|continue|do|else|finally|for|function|if|in|instanceof|new|null|return|throw|try|while)\b/,
	'boolean': /\b(?:false|true)\b/,
	'function': /\b\w+(?=\()/,
	'number': /\b0x[\da-f]+\b|(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:e[+-]?\d+)?/i,
	'operator': /[<>]=?|[!=]=?=?|--?|\+\+?|&&?|\|\|?|[?*/~^%]/,
	'punctuation': /[{}[\];(),.:]/
};

Prism.languages.javascript = Prism.languages.extend('clike', {
	'class-name': [
		Prism.languages.clike['class-name'],
		{
			pattern: /(^|[^$\w\xA0-\uFFFF])(?!\s)[_$A-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*(?=\.(?:constructor|prototype))/,
			lookbehind: true
		}
	],
	'keyword': [
		{
			pattern: /((?:^|\})\s*)catch\b/,
			lookbehind: true
		},
		{
			pattern: /(^|[^.]|\.\.\.\s*)\b(?:as|assert(?=\s*\{)|async(?=\s*(?:function\b|\(|[$\w\xA0-\uFFFF]|$))|await|break|case|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally(?=\s*(?:\{|$))|for|from(?=\s*(?:['"]|$))|function|(?:get|set)(?=\s*(?:[#\[$\w\xA0-\uFFFF]|$))|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)\b/,
			lookbehind: true
		},
	],
	// Allow for all non-ASCII characters (See http://stackoverflow.com/a/2008444)
	'function': /#?(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*(?=\s*(?:\.\s*(?:apply|bind|call)\s*)?\()/,
	'number': {
		pattern: RegExp(
			/(^|[^\w$])/.source +
			'(?:' +
			(
				// constant
				/NaN|Infinity/.source +
				'|' +
				// binary integer
				/0[bB][01]+(?:_[01]+)*n?/.source +
				'|' +
				// octal integer
				/0[oO][0-7]+(?:_[0-7]+)*n?/.source +
				'|' +
				// hexadecimal integer
				/0[xX][\dA-Fa-f]+(?:_[\dA-Fa-f]+)*n?/.source +
				'|' +
				// decimal bigint
				/\d+(?:_\d+)*n/.source +
				'|' +
				// decimal number (integer or float) but no bigint
				/(?:\d+(?:_\d+)*(?:\.(?:\d+(?:_\d+)*)?)?|\.\d+(?:_\d+)*)(?:[Ee][+-]?\d+(?:_\d+)*)?/.source
			) +
			')' +
			/(?![\w$])/.source
		),
		lookbehind: true
	},
	'operator': /--|\+\+|\*\*=?|=>|&&=?|\|\|=?|[!=]==|<<=?|>>>?=?|[-+*/%&|^!=<>]=?|\.{3}|\?\?=?|\?\.?|[~:]/
});

Prism.languages.javascript['class-name'][0].pattern = /(\b(?:class|extends|implements|instanceof|interface|new)\s+)[\w.\\]+/;

Prism.languages.insertBefore('javascript', 'keyword', {
	'regex': {
		pattern: RegExp(
			// lookbehind
			// eslint-disable-next-line regexp/no-dupe-characters-character-class
			/((?:^|[^$\w\xA0-\uFFFF."'\])\s]|\b(?:return|yield))\s*)/.source +
			// Regex pattern:
			// There are 2 regex patterns here. The RegExp set notation proposal added support for nested character
			// classes if the `v` flag is present. Unfortunately, nested CCs are both context-free and incompatible
			// with the only syntax, so we have to define 2 different regex patterns.
			/\//.source +
			'(?:' +
			/(?:\[(?:[^\]\\\r\n]|\\.)*\]|\\.|[^/\\\[\r\n])+\/[dgimyus]{0,7}/.source +
			'|' +
			// `v` flag syntax. This supports 3 levels of nested character classes.
			/(?:\[(?:[^[\]\\\r\n]|\\.|\[(?:[^[\]\\\r\n]|\\.|\[(?:[^[\]\\\r\n]|\\.)*\])*\])*\]|\\.|[^/\\\[\r\n])+\/[dgimyus]{0,7}v[dgimyus]{0,7}/.source +
			')' +
			// lookahead
			/(?=(?:\s|\/\*(?:[^*]|\*(?!\/))*\*\/)*(?:$|[\r\n,.;:})\]]|\/\/))/.source
		),
		lookbehind: true,
		greedy: true,
		inside: {
			'regex-source': {
				pattern: /^(\/)[\s\S]+(?=\/[a-z]*$)/,
				lookbehind: true,
				alias: 'language-regex',
				inside: Prism.languages.regex
			},
			'regex-delimiter': /^\/|\/$/,
			'regex-flags': /^[a-z]+$/,
		}
	},
	// This must be declared before keyword because we use "function" inside the look-forward
	'function-variable': {
		pattern: /#?(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*(?=\s*[=:]\s*(?:async\s*)?(?:\bfunction\b|(?:\((?:[^()]|\([^()]*\))*\)|(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*)\s*=>))/,
		alias: 'function'
	},
	'parameter': [
		{
			pattern: /(function(?:\s+(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*)?\s*\(\s*)(?!\s)(?:[^()\s]|\s+(?![\s)])|\([^()]*\))+(?=\s*\))/,
			lookbehind: true,
			inside: Prism.languages.javascript
		},
		{
			pattern: /(^|[^$\w\xA0-\uFFFF])(?!\s)[_$a-z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*(?=\s*=>)/i,
			lookbehind: true,
			inside: Prism.languages.javascript
		},
		{
			pattern: /(\(\s*)(?!\s)(?:[^()\s]|\s+(?![\s)])|\([^()]*\))+(?=\s*\)\s*=>)/,
			lookbehind: true,
			inside: Prism.languages.javascript
		},
		{
			pattern: /((?:\b|\s|^)(?!(?:as|async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|set|static|super|switch|this|throw|try|typeof|undefined|var|void|while|with|yield)(?![$\w\xA0-\uFFFF]))(?:(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*\s*)\(\s*|\]\s*\(\s*)(?!\s)(?:[^()\s]|\s+(?![\s)])|\([^()]*\))+(?=\s*\)\s*\{)/,
			lookbehind: true,
			inside: Prism.languages.javascript
		}
	],
	'constant': /\b[A-Z](?:[A-Z_]|\dx?)*\b/
});

Prism.languages.insertBefore('javascript', 'string', {
	'hashbang': {
		pattern: /^#!.*/,
		greedy: true,
		alias: 'comment'
	},
	'template-string': {
		pattern: /`(?:\\[\s\S]|\$\{(?:[^{}]|\{(?:[^{}]|\{[^}]*\})*\})+\}|(?!\$\{)[^\\`])*`/,
		greedy: true,
		inside: {
			'template-punctuation': {
				pattern: /^`|`$/,
				alias: 'string'
			},
			'interpolation': {
				pattern: /((?:^|[^\\])(?:\\{2})*)\$\{(?:[^{}]|\{(?:[^{}]|\{[^}]*\})*\})+\}/,
				lookbehind: true,
				inside: {
					'interpolation-punctuation': {
						pattern: /^\$\{|\}$/,
						alias: 'punctuation'
					},
					rest: Prism.languages.javascript
				}
			},
			'string': /[\s\S]+/
		}
	},
	'string-property': {
		pattern: /((?:^|[,{])[ \t]*)(["'])(?:\\(?:\r\n|[\s\S])|(?!\2)[^\\\r\n])*\2(?=\s*:)/m,
		lookbehind: true,
		greedy: true,
		alias: 'property'
	}
});

Prism.languages.insertBefore('javascript', 'operator', {
	'literal-property': {
		pattern: /((?:^|[,{])[ \t]*)(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*(?=\s*:)/m,
		lookbehind: true,
		alias: 'property'
	},
});

if (Prism.languages.markup) {
	Prism.languages.markup.tag.addInlined('script', 'javascript');

	// add attribute support for all DOM events.
	// https://developer.mozilla.org/en-US/docs/Web/Events#Standard_events
	Prism.languages.markup.tag.addAttribute(
		/on(?:abort|blur|change|click|composition(?:end|start|update)|dblclick|error|focus(?:in|out)?|key(?:down|up)|load|mouse(?:down|enter|leave|move|out|over|up)|reset|resize|scroll|select|slotchange|submit|unload|wheel)/.source,
		'javascript'
	);
}

Prism.languages.js = Prism.languages.javascript;

Prism.languages.abap = {
	'comment': /^\*.*/m,
	'string': /(`|')(?:\\.|(?!\1)[^\\\r\n])*\1/,
	'string-template': {
		pattern: /([|}])(?:\\.|[^\\|{\r\n])*(?=[|{])/,
		lookbehind: true,
		alias: 'string'
	},
	/* End Of Line comments should not interfere with strings when the
	quote character occurs within them. We assume a string being highlighted
	inside an EOL comment is more acceptable than the opposite.
	*/
	'eol-comment': {
		pattern: /(^|\s)".*/m,
		lookbehind: true,
		alias: 'comment'
	},
	'keyword': {
		pattern: /(\s|\.|^)(?:\*-INPUT|\?TO|ABAP-SOURCE|ABBREVIATED|ABS|ABSTRACT|ACCEPT|ACCEPTING|ACCESSPOLICY|ACCORDING|ACOS|ACTIVATION|ACTUAL|ADD|ADD-CORRESPONDING|ADJACENT|AFTER|ALIAS|ALIASES|ALIGN|ALL|ALLOCATE|ALPHA|ANALYSIS|ANALYZER|AND|ANY|APPEND|APPENDAGE|APPENDING|APPLICATION|ARCHIVE|AREA|ARITHMETIC|AS|ASCENDING|ASIN|ASPECT|ASSERT|ASSIGN|ASSIGNED|ASSIGNING|ASSOCIATION|ASYNCHRONOUS|AT|ATAN|ATTRIBUTES|AUTHORITY|AUTHORITY-CHECK|AVG|BACK|BACKGROUND|BACKUP|BACKWARD|BADI|BASE|BEFORE|BEGIN|BETWEEN|BIG|BINARY|BINDING|BIT|BIT-AND|BIT-NOT|BIT-OR|BIT-XOR|BLACK|BLANK|BLANKS|BLOB|BLOCK|BLOCKS|BLUE|BOUND|BOUNDARIES|BOUNDS|BOXED|BREAK-POINT|BT|BUFFER|BY|BYPASSING|BYTE|BYTE-CA|BYTE-CN|BYTE-CO|BYTE-CS|BYTE-NA|BYTE-NS|BYTE-ORDER|C|CA|CALL|CALLING|CASE|CAST|CASTING|CATCH|CEIL|CENTER|CENTERED|CHAIN|CHAIN-INPUT|CHAIN-REQUEST|CHANGE|CHANGING|CHANNELS|CHAR-TO-HEX|CHARACTER|CHARLEN|CHECK|CHECKBOX|CIRCULAR|CI_|CLASS|CLASS-CODING|CLASS-DATA|CLASS-EVENTS|CLASS-METHODS|CLASS-POOL|CLEANUP|CLEAR|CLIENT|CLOB|CLOCK|CLOSE|CN|CNT|CO|COALESCE|CODE|CODING|COLLECT|COLOR|COLUMN|COLUMNS|COL_BACKGROUND|COL_GROUP|COL_HEADING|COL_KEY|COL_NEGATIVE|COL_NORMAL|COL_POSITIVE|COL_TOTAL|COMMENT|COMMENTS|COMMIT|COMMON|COMMUNICATION|COMPARING|COMPONENT|COMPONENTS|COMPRESSION|COMPUTE|CONCAT|CONCATENATE|COND|CONDENSE|CONDITION|CONNECT|CONNECTION|CONSTANTS|CONTEXT|CONTEXTS|CONTINUE|CONTROL|CONTROLS|CONV|CONVERSION|CONVERT|COPIES|COPY|CORRESPONDING|COS|COSH|COUNT|COUNTRY|COVER|CP|CPI|CREATE|CREATING|CRITICAL|CS|CURRENCY|CURRENCY_CONVERSION|CURRENT|CURSOR|CURSOR-SELECTION|CUSTOMER|CUSTOMER-FUNCTION|DANGEROUS|DATA|DATABASE|DATAINFO|DATASET|DATE|DAYLIGHT|DBMAXLEN|DD\/MM\/YY|DD\/MM\/YYYY|DDMMYY|DEALLOCATE|DECIMALS|DECIMAL_SHIFT|DECLARATIONS|DEEP|DEFAULT|DEFERRED|DEFINE|DEFINING|DEFINITION|DELETE|DELETING|DEMAND|DEPARTMENT|DESCENDING|DESCRIBE|DESTINATION|DETAIL|DIALOG|DIRECTORY|DISCONNECT|DISPLAY|DISPLAY-MODE|DISTANCE|DISTINCT|DIV|DIVIDE|DIVIDE-CORRESPONDING|DIVISION|DO|DUMMY|DUPLICATE|DUPLICATES|DURATION|DURING|DYNAMIC|DYNPRO|E|EACH|EDIT|EDITOR-CALL|ELSE|ELSEIF|EMPTY|ENABLED|ENABLING|ENCODING|END|END-ENHANCEMENT-SECTION|END-LINES|END-OF-DEFINITION|END-OF-FILE|END-OF-PAGE|END-OF-SELECTION|ENDAT|ENDCASE|ENDCATCH|ENDCHAIN|ENDCLASS|ENDDO|ENDENHANCEMENT|ENDEXEC|ENDFOR|ENDFORM|ENDFUNCTION|ENDIAN|ENDIF|ENDING|ENDINTERFACE|ENDLOOP|ENDMETHOD|ENDMODULE|ENDON|ENDPROVIDE|ENDSELECT|ENDTRY|ENDWHILE|ENGINEERING|ENHANCEMENT|ENHANCEMENT-POINT|ENHANCEMENT-SECTION|ENHANCEMENTS|ENTRIES|ENTRY|ENVIRONMENT|EQ|EQUAL|EQUIV|ERRORMESSAGE|ERRORS|ESCAPE|ESCAPING|EVENT|EVENTS|EXACT|EXCEPT|EXCEPTION|EXCEPTION-TABLE|EXCEPTIONS|EXCLUDE|EXCLUDING|EXEC|EXECUTE|EXISTS|EXIT|EXIT-COMMAND|EXP|EXPAND|EXPANDING|EXPIRATION|EXPLICIT|EXPONENT|EXPORT|EXPORTING|EXTEND|EXTENDED|EXTENSION|EXTRACT|FAIL|FETCH|FIELD|FIELD-GROUPS|FIELD-SYMBOL|FIELD-SYMBOLS|FIELDS|FILE|FILTER|FILTER-TABLE|FILTERS|FINAL|FIND|FIRST|FIRST-LINE|FIXED-POINT|FKEQ|FKGE|FLOOR|FLUSH|FONT|FOR|FORM|FORMAT|FORWARD|FOUND|FRAC|FRAME|FRAMES|FREE|FRIENDS|FROM|FUNCTION|FUNCTION-POOL|FUNCTIONALITY|FURTHER|GAPS|GE|GENERATE|GET|GIVING|GKEQ|GKGE|GLOBAL|GRANT|GREATER|GREEN|GROUP|GROUPS|GT|HANDLE|HANDLER|HARMLESS|HASHED|HAVING|HDB|HEAD-LINES|HEADER|HEADERS|HEADING|HELP-ID|HELP-REQUEST|HIDE|HIGH|HINT|HOLD|HOTSPOT|I|ICON|ID|IDENTIFICATION|IDENTIFIER|IDS|IF|IGNORE|IGNORING|IMMEDIATELY|IMPLEMENTATION|IMPLEMENTATIONS|IMPLEMENTED|IMPLICIT|IMPORT|IMPORTING|IN|INACTIVE|INCL|INCLUDE|INCLUDES|INCLUDING|INCREMENT|INDEX|INDEX-LINE|INFOTYPES|INHERITING|INIT|INITIAL|INITIALIZATION|INNER|INOUT|INPUT|INSERT|INSTANCES|INTENSIFIED|INTERFACE|INTERFACE-POOL|INTERFACES|INTERNAL|INTERVALS|INTO|INVERSE|INVERTED-DATE|IS|ISO|ITERATOR|ITNO|JOB|JOIN|KEEP|KEEPING|KERNEL|KEY|KEYS|KEYWORDS|KIND|LANGUAGE|LAST|LATE|LAYOUT|LE|LEADING|LEAVE|LEFT|LEFT-JUSTIFIED|LEFTPLUS|LEFTSPACE|LEGACY|LENGTH|LESS|LET|LEVEL|LEVELS|LIKE|LINE|LINE-COUNT|LINE-SELECTION|LINE-SIZE|LINEFEED|LINES|LIST|LIST-PROCESSING|LISTBOX|LITTLE|LLANG|LOAD|LOAD-OF-PROGRAM|LOB|LOCAL|LOCALE|LOCATOR|LOG|LOG-POINT|LOG10|LOGFILE|LOGICAL|LONG|LOOP|LOW|LOWER|LPAD|LPI|LT|M|MAIL|MAIN|MAJOR-ID|MAPPING|MARGIN|MARK|MASK|MATCH|MATCHCODE|MAX|MAXIMUM|MEDIUM|MEMBERS|MEMORY|MESH|MESSAGE|MESSAGE-ID|MESSAGES|MESSAGING|METHOD|METHODS|MIN|MINIMUM|MINOR-ID|MM\/DD\/YY|MM\/DD\/YYYY|MMDDYY|MOD|MODE|MODIF|MODIFIER|MODIFY|MODULE|MOVE|MOVE-CORRESPONDING|MULTIPLY|MULTIPLY-CORRESPONDING|NA|NAME|NAMETAB|NATIVE|NB|NE|NESTED|NESTING|NEW|NEW-LINE|NEW-PAGE|NEW-SECTION|NEXT|NO|NO-DISPLAY|NO-EXTENSION|NO-GAP|NO-GAPS|NO-GROUPING|NO-HEADING|NO-SCROLLING|NO-SIGN|NO-TITLE|NO-TOPOFPAGE|NO-ZERO|NODE|NODES|NON-UNICODE|NON-UNIQUE|NOT|NP|NS|NULL|NUMBER|NUMOFCHAR|O|OBJECT|OBJECTS|OBLIGATORY|OCCURRENCE|OCCURRENCES|OCCURS|OF|OFF|OFFSET|OLE|ON|ONLY|OPEN|OPTION|OPTIONAL|OPTIONS|OR|ORDER|OTHER|OTHERS|OUT|OUTER|OUTPUT|OUTPUT-LENGTH|OVERFLOW|OVERLAY|PACK|PACKAGE|PAD|PADDING|PAGE|PAGES|PARAMETER|PARAMETER-TABLE|PARAMETERS|PART|PARTIALLY|PATTERN|PERCENTAGE|PERFORM|PERFORMING|PERSON|PF|PF-STATUS|PINK|PLACES|POOL|POSITION|POS_HIGH|POS_LOW|PRAGMAS|PRECOMPILED|PREFERRED|PRESERVING|PRIMARY|PRINT|PRINT-CONTROL|PRIORITY|PRIVATE|PROCEDURE|PROCESS|PROGRAM|PROPERTY|PROTECTED|PROVIDE|PUBLIC|PUSHBUTTON|PUT|QUEUE-ONLY|QUICKINFO|RADIOBUTTON|RAISE|RAISING|RANGE|RANGES|RAW|READ|READ-ONLY|READER|RECEIVE|RECEIVED|RECEIVER|RECEIVING|RED|REDEFINITION|REDUCE|REDUCED|REF|REFERENCE|REFRESH|REGEX|REJECT|REMOTE|RENAMING|REPLACE|REPLACEMENT|REPLACING|REPORT|REQUEST|REQUESTED|RESERVE|RESET|RESOLUTION|RESPECTING|RESPONSIBLE|RESULT|RESULTS|RESUMABLE|RESUME|RETRY|RETURN|RETURNCODE|RETURNING|RIGHT|RIGHT-JUSTIFIED|RIGHTPLUS|RIGHTSPACE|RISK|RMC_COMMUNICATION_FAILURE|RMC_INVALID_STATUS|RMC_SYSTEM_FAILURE|ROLE|ROLLBACK|ROUND|ROWS|RTTI|RUN|SAP|SAP-SPOOL|SAVING|SCALE_PRESERVING|SCALE_PRESERVING_SCIENTIFIC|SCAN|SCIENTIFIC|SCIENTIFIC_WITH_LEADING_ZERO|SCREEN|SCROLL|SCROLL-BOUNDARY|SCROLLING|SEARCH|SECONDARY|SECONDS|SECTION|SELECT|SELECT-OPTIONS|SELECTION|SELECTION-SCREEN|SELECTION-SET|SELECTION-SETS|SELECTION-TABLE|SELECTIONS|SELECTOR|SEND|SEPARATE|SEPARATED|SET|SHARED|SHIFT|SHORT|SHORTDUMP-ID|SIGN|SIGN_AS_POSTFIX|SIMPLE|SIN|SINGLE|SINH|SIZE|SKIP|SKIPPING|SMART|SOME|SORT|SORTABLE|SORTED|SOURCE|SPACE|SPECIFIED|SPLIT|SPOOL|SPOTS|SQL|SQLSCRIPT|SQRT|STABLE|STAMP|STANDARD|START-OF-SELECTION|STARTING|STATE|STATEMENT|STATEMENTS|STATIC|STATICS|STATUSINFO|STEP-LOOP|STOP|STRLEN|STRUCTURE|STRUCTURES|STYLE|SUBKEY|SUBMATCHES|SUBMIT|SUBROUTINE|SUBSCREEN|SUBSTRING|SUBTRACT|SUBTRACT-CORRESPONDING|SUFFIX|SUM|SUMMARY|SUMMING|SUPPLIED|SUPPLY|SUPPRESS|SWITCH|SWITCHSTATES|SYMBOL|SYNCPOINTS|SYNTAX|SYNTAX-CHECK|SYNTAX-TRACE|SYSTEM-CALL|SYSTEM-EXCEPTIONS|SYSTEM-EXIT|TAB|TABBED|TABLE|TABLES|TABLEVIEW|TABSTRIP|TAN|TANH|TARGET|TASK|TASKS|TEST|TESTING|TEXT|TEXTPOOL|THEN|THROW|TIME|TIMES|TIMESTAMP|TIMEZONE|TITLE|TITLE-LINES|TITLEBAR|TO|TOKENIZATION|TOKENS|TOP-LINES|TOP-OF-PAGE|TRACE-FILE|TRACE-TABLE|TRAILING|TRANSACTION|TRANSFER|TRANSFORMATION|TRANSLATE|TRANSPORTING|TRMAC|TRUNC|TRUNCATE|TRUNCATION|TRY|TYPE|TYPE-POOL|TYPE-POOLS|TYPES|ULINE|UNASSIGN|UNDER|UNICODE|UNION|UNIQUE|UNIT|UNIT_CONVERSION|UNIX|UNPACK|UNTIL|UNWIND|UP|UPDATE|UPPER|USER|USER-COMMAND|USING|UTF-8|VALID|VALUE|VALUE-REQUEST|VALUES|VARY|VARYING|VERIFICATION-MESSAGE|VERSION|VIA|VIEW|VISIBLE|WAIT|WARNING|WHEN|WHENEVER|WHERE|WHILE|WIDTH|WINDOW|WINDOWS|WITH|WITH-HEADING|WITH-TITLE|WITHOUT|WORD|WORK|WRITE|WRITER|X|XML|XOR|XSD|XSTRLEN|YELLOW|YES|YYMMDD|Z|ZERO|ZONE)(?![\w-])/i,
		lookbehind: true
	},
	/* Numbers can be only integers. Decimal or Hex appear only as strings */
	'number': /\b\d+\b/,
	/* Operators must always be surrounded by whitespace, they cannot be put
	adjacent to operands.
	*/
	'operator': {
		pattern: /(\s)(?:\*\*?|<[=>]?|>=?|\?=|[-+\/=])(?=\s)/,
		lookbehind: true
	},
	'string-operator': {
		pattern: /(\s)&&?(?=\s)/,
		lookbehind: true,
		/* The official editor highlights */
		alias: 'keyword'
	},
	'token-operator': [{
		/* Special operators used to access structure components, class methods/attributes, etc. */
		pattern: /(\w)(?:->?|=>|[~|{}])(?=\w)/,
		lookbehind: true,
		alias: 'punctuation'
	}, {
		/* Special tokens used do delimit string templates */
		pattern: /[|{}]/,
		alias: 'punctuation'
	}],
	'punctuation': /[,.:()]/
};

Prism.languages.ada = {
	'comment': /--.*/,
	'string': /"(?:""|[^"\r\f\n])*"/,
	'number': [
		{
			pattern: /\b\d(?:_?\d)*#[\dA-F](?:_?[\dA-F])*(?:\.[\dA-F](?:_?[\dA-F])*)?#(?:E[+-]?\d(?:_?\d)*)?/i
		},
		{
			pattern: /\b\d(?:_?\d)*(?:\.\d(?:_?\d)*)?(?:E[+-]?\d(?:_?\d)*)?\b/i
		}
	],
	'attribute': {
		pattern: /\b'\w+/,
		alias: 'attr-name'
	},
	'keyword': /\b(?:abort|abs|abstract|accept|access|aliased|all|and|array|at|begin|body|case|constant|declare|delay|delta|digits|do|else|elsif|end|entry|exception|exit|for|function|generic|goto|if|in|interface|is|limited|loop|mod|new|not|null|of|or|others|out|overriding|package|pragma|private|procedure|protected|raise|range|record|rem|renames|requeue|return|reverse|select|separate|some|subtype|synchronized|tagged|task|terminate|then|type|until|use|when|while|with|xor)\b/i,
	'boolean': /\b(?:false|true)\b/i,
	'operator': /<[=>]?|>=?|=>?|:=|\/=?|\*\*?|[&+-]/,
	'punctuation': /\.\.?|[,;():]/,
	'char': /'.'/,
	'variable': /\b[a-z](?:\w)*\b/i
};

Prism.languages.c = Prism.languages.extend('clike', {
	'comment': {
		pattern: /\/\/(?:[^\r\n\\]|\\(?:\r\n?|\n|(?![\r\n])))*|\/\*[\s\S]*?(?:\*\/|$)/,
		greedy: true
	},
	'string': {
		// https://en.cppreference.com/w/c/language/string_literal
		pattern: /"(?:\\(?:\r\n|[\s\S])|[^"\\\r\n])*"/,
		greedy: true
	},
	'class-name': {
		pattern: /(\b(?:enum|struct)\s+(?:__attribute__\s*\(\([\s\S]*?\)\)\s*)?)\w+|\b[a-z]\w*_t\b/,
		lookbehind: true
	},
	'keyword': /\b(?:_Alignas|_Alignof|_Atomic|_Bool|_Complex|_Generic|_Imaginary|_Noreturn|_Static_assert|_Thread_local|__attribute__|asm|auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|inline|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|typeof|union|unsigned|void|volatile|while)\b/,
	'function': /\b[a-z_]\w*(?=\s*\()/i,
	'number': /(?:\b0x(?:[\da-f]+(?:\.[\da-f]*)?|\.[\da-f]+)(?:p[+-]?\d+)?|(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:e[+-]?\d+)?)[ful]{0,4}/i,
	'operator': />>=?|<<=?|->|([-+&|:])\1|[?:~]|[-+*/%&|^!=<>]=?/
});

Prism.languages.insertBefore('c', 'string', {
	'char': {
		// https://en.cppreference.com/w/c/language/character_constant
		pattern: /'(?:\\(?:\r\n|[\s\S])|[^'\\\r\n]){0,32}'/,
		greedy: true
	}
});

Prism.languages.insertBefore('c', 'string', {
	'macro': {
		// allow for multiline macro definitions
		// spaces after the # character compile fine with gcc
		pattern: /(^[\t ]*)#\s*[a-z](?:[^\r\n\\/]|\/(?!\*)|\/\*(?:[^*]|\*(?!\/))*\*\/|\\(?:\r\n|[\s\S]))*/im,
		lookbehind: true,
		greedy: true,
		alias: 'property',
		inside: {
			'string': [
				{
					// highlight the path of the include statement as a string
					pattern: /^(#\s*include\s*)<[^>]+>/,
					lookbehind: true
				},
				Prism.languages.c['string']
			],
			'char': Prism.languages.c['char'],
			'comment': Prism.languages.c['comment'],
			'macro-name': [
				{
					pattern: /(^#\s*define\s+)\w+\b(?!\()/i,
					lookbehind: true
				},
				{
					pattern: /(^#\s*define\s+)\w+\b(?=\()/i,
					lookbehind: true,
					alias: 'function'
				}
			],
			// highlight macro directives as keywords
			'directive': {
				pattern: /^(#\s*)[a-z]+/,
				lookbehind: true,
				alias: 'keyword'
			},
			'directive-hash': /^#/,
			'punctuation': /##|\\(?=[\r\n])/,
			'expression': {
				pattern: /\S[\s\S]*/,
				inside: Prism.languages.c
			}
		}
	}
});

Prism.languages.insertBefore('c', 'function', {
	// highlight predefined macros as constants
	'constant': /\b(?:EOF|NULL|SEEK_CUR|SEEK_END|SEEK_SET|__DATE__|__FILE__|__LINE__|__TIMESTAMP__|__TIME__|__func__|stderr|stdin|stdout)\b/
});

delete Prism.languages.c['boolean'];

(function (Prism) {

	var keyword = /\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|char8_t|class|co_await|co_return|co_yield|compl|concept|const|const_cast|consteval|constexpr|constinit|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|final|float|for|friend|goto|if|import|inline|int|int16_t|int32_t|int64_t|int8_t|long|module|mutable|namespace|new|noexcept|nullptr|operator|override|private|protected|public|register|reinterpret_cast|requires|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|uint16_t|uint32_t|uint64_t|uint8_t|union|unsigned|using|virtual|void|volatile|wchar_t|while)\b/;
	var modName = /\b(?!<keyword>)\w+(?:\s*\.\s*\w+)*\b/.source.replace(/<keyword>/g, function () { return keyword.source; });

	Prism.languages.cpp = Prism.languages.extend('c', {
		'class-name': [
			{
				pattern: RegExp(/(\b(?:class|concept|enum|struct|typename)\s+)(?!<keyword>)\w+/.source
					.replace(/<keyword>/g, function () { return keyword.source; })),
				lookbehind: true
			},
			// This is intended to capture the class name of method implementations like:
			//   void foo::bar() const {}
			// However! The `foo` in the above example could also be a namespace, so we only capture the class name if
			// it starts with an uppercase letter. This approximation should give decent results.
			/\b[A-Z]\w*(?=\s*::\s*\w+\s*\()/,
			// This will capture the class name before destructors like:
			//   Foo::~Foo() {}
			/\b[A-Z_]\w*(?=\s*::\s*~\w+\s*\()/i,
			// This also intends to capture the class name of method implementations but here the class has template
			// parameters, so it can't be a namespace (until C++ adds generic namespaces).
			/\b\w+(?=\s*<(?:[^<>]|<(?:[^<>]|<[^<>]*>)*>)*>\s*::\s*\w+\s*\()/
		],
		'keyword': keyword,
		'number': {
			pattern: /(?:\b0b[01']+|\b0x(?:[\da-f']+(?:\.[\da-f']*)?|\.[\da-f']+)(?:p[+-]?[\d']+)?|(?:\b[\d']+(?:\.[\d']*)?|\B\.[\d']+)(?:e[+-]?[\d']+)?)[ful]{0,4}/i,
			greedy: true
		},
		'operator': />>=?|<<=?|->|--|\+\+|&&|\|\||[?:~]|<=>|[-+*/%&|^!=<>]=?|\b(?:and|and_eq|bitand|bitor|not|not_eq|or|or_eq|xor|xor_eq)\b/,
		'boolean': /\b(?:false|true)\b/
	});

	Prism.languages.insertBefore('cpp', 'string', {
		'module': {
			// https://en.cppreference.com/w/cpp/language/modules
			pattern: RegExp(
				/(\b(?:import|module)\s+)/.source +
				'(?:' +
				// header-name
				/"(?:\\(?:\r\n|[\s\S])|[^"\\\r\n])*"|<[^<>\r\n]*>/.source +
				'|' +
				// module name or partition or both
				/<mod-name>(?:\s*:\s*<mod-name>)?|:\s*<mod-name>/.source.replace(/<mod-name>/g, function () { return modName; }) +
				')'
			),
			lookbehind: true,
			greedy: true,
			inside: {
				'string': /^[<"][\s\S]+/,
				'operator': /:/,
				'punctuation': /\./
			}
		},
		'raw-string': {
			pattern: /R"([^()\\ ]{0,16})\([\s\S]*?\)\1"/,
			alias: 'string',
			greedy: true
		}
	});

	Prism.languages.insertBefore('cpp', 'keyword', {
		'generic-function': {
			pattern: /\b(?!operator\b)[a-z_]\w*\s*<(?:[^<>]|<[^<>]*>)*>(?=\s*\()/i,
			inside: {
				'function': /^\w+/,
				'generic': {
					pattern: /<[\s\S]+/,
					alias: 'class-name',
					inside: Prism.languages.cpp
				}
			}
		}
	});

	Prism.languages.insertBefore('cpp', 'operator', {
		'double-colon': {
			pattern: /::/,
			alias: 'punctuation'
		}
	});

	Prism.languages.insertBefore('cpp', 'class-name', {
		// the base clause is an optional list of parent classes
		// https://en.cppreference.com/w/cpp/language/class
		'base-clause': {
			pattern: /(\b(?:class|struct)\s+\w+\s*:\s*)[^;{}"'\s]+(?:\s+[^;{}"'\s]+)*(?=\s*[;{])/,
			lookbehind: true,
			greedy: true,
			inside: Prism.languages.extend('cpp', {})
		}
	});

	Prism.languages.insertBefore('inside', 'double-colon', {
		// All untokenized words that are not namespaces should be class names
		'class-name': /\b[a-z_]\w*\b(?!\s*::)/i
	}, Prism.languages.cpp['base-clause']);

}(Prism));

Prism.languages.arduino = Prism.languages.extend('cpp', {
	'keyword': /\b(?:String|array|bool|boolean|break|byte|case|catch|continue|default|do|double|else|finally|for|function|goto|if|in|instanceof|int|integer|long|loop|new|null|return|setup|string|switch|throw|try|void|while|word)\b/,
	'constant': /\b(?:ANALOG_MESSAGE|DEFAULT|DIGITAL_MESSAGE|EXTERNAL|FIRMATA_STRING|HIGH|INPUT|INPUT_PULLUP|INTERNAL|INTERNAL1V1|INTERNAL2V56|LED_BUILTIN|LOW|OUTPUT|REPORT_ANALOG|REPORT_DIGITAL|SET_PIN_MODE|SYSEX_START|SYSTEM_RESET)\b/,
	'builtin': /\b(?:Audio|BSSID|Bridge|Client|Console|EEPROM|Esplora|EsploraTFT|Ethernet|EthernetClient|EthernetServer|EthernetUDP|File|FileIO|FileSystem|Firmata|GPRS|GSM|GSMBand|GSMClient|GSMModem|GSMPIN|GSMScanner|GSMServer|GSMVoiceCall|GSM_SMS|HttpClient|IPAddress|IRread|Keyboard|KeyboardController|LiquidCrystal|LiquidCrystal_I2C|Mailbox|Mouse|MouseController|PImage|Process|RSSI|RobotControl|RobotMotor|SD|SPI|SSID|Scheduler|Serial|Server|Servo|SoftwareSerial|Stepper|Stream|TFT|Task|USBHost|WiFi|WiFiClient|WiFiServer|WiFiUDP|Wire|YunClient|YunServer|abs|addParameter|analogRead|analogReadResolution|analogReference|analogWrite|analogWriteResolution|answerCall|attach|attachGPRS|attachInterrupt|attached|autoscroll|available|background|beep|begin|beginPacket|beginSD|beginSMS|beginSpeaker|beginTFT|beginTransmission|beginWrite|bit|bitClear|bitRead|bitSet|bitWrite|blink|blinkVersion|buffer|changePIN|checkPIN|checkPUK|checkReg|circle|cityNameRead|cityNameWrite|clear|clearScreen|click|close|compassRead|config|connect|connected|constrain|cos|countryNameRead|countryNameWrite|createChar|cursor|debugPrint|delay|delayMicroseconds|detach|detachInterrupt|digitalRead|digitalWrite|disconnect|display|displayLogos|drawBMP|drawCompass|encryptionType|end|endPacket|endSMS|endTransmission|endWrite|exists|exitValue|fill|find|findUntil|flush|gatewayIP|get|getAsynchronously|getBand|getButton|getCurrentCarrier|getIMEI|getKey|getModifiers|getOemKey|getPINUsed|getResult|getSignalStrength|getSocket|getVoiceCallStatus|getXChange|getYChange|hangCall|height|highByte|home|image|interrupts|isActionDone|isDirectory|isListening|isPIN|isPressed|isValid|keyPressed|keyReleased|keyboardRead|knobRead|leftToRight|line|lineFollowConfig|listen|listenOnLocalhost|loadImage|localIP|lowByte|macAddress|maintain|map|max|messageAvailable|micros|millis|min|mkdir|motorsStop|motorsWrite|mouseDragged|mouseMoved|mousePressed|mouseReleased|move|noAutoscroll|noBlink|noBuffer|noCursor|noDisplay|noFill|noInterrupts|noListenOnLocalhost|noStroke|noTone|onReceive|onRequest|open|openNextFile|overflow|parseCommand|parseFloat|parseInt|parsePacket|pauseMode|peek|pinMode|playFile|playMelody|point|pointTo|position|pow|prepare|press|print|printFirmwareVersion|printVersion|println|process|processInput|pulseIn|put|random|randomSeed|read|readAccelerometer|readBlue|readButton|readBytes|readBytesUntil|readGreen|readJoystickButton|readJoystickSwitch|readJoystickX|readJoystickY|readLightSensor|readMessage|readMicrophone|readNetworks|readRed|readSlider|readString|readStringUntil|readTemperature|ready|rect|release|releaseAll|remoteIP|remoteNumber|remotePort|remove|requestFrom|retrieveCallingNumber|rewindDirectory|rightToLeft|rmdir|robotNameRead|robotNameWrite|run|runAsynchronously|runShellCommand|runShellCommandAsynchronously|running|scanNetworks|scrollDisplayLeft|scrollDisplayRight|seek|sendAnalog|sendDigitalPortPair|sendDigitalPorts|sendString|sendSysex|serialEvent|setBand|setBitOrder|setClockDivider|setCursor|setDNS|setDataMode|setFirmwareVersion|setMode|setPINUsed|setSpeed|setTextSize|setTimeout|shiftIn|shiftOut|shutdown|sin|size|sqrt|startLoop|step|stop|stroke|subnetMask|switchPIN|tan|tempoWrite|text|tone|transfer|tuneWrite|turn|updateIR|userNameRead|userNameWrite|voiceCall|waitContinue|width|write|writeBlue|writeGreen|writeJSON|writeMessage|writeMicroseconds|writeRGB|writeRed|yield)\b/
});

Prism.languages.ino = Prism.languages.arduino;

(function (Prism) {

	var attributes = {
		pattern: /(^[ \t]*)\[(?!\[)(?:(["'$`])(?:(?!\2)[^\\]|\\.)*\2|\[(?:[^\[\]\\]|\\.)*\]|[^\[\]\\"'$`]|\\.)*\]/m,
		lookbehind: true,
		inside: {
			'quoted': {
				pattern: /([$`])(?:(?!\1)[^\\]|\\.)*\1/,
				inside: {
					'punctuation': /^[$`]|[$`]$/
				}
			},
			'interpreted': {
				pattern: /'(?:[^'\\]|\\.)*'/,
				inside: {
					'punctuation': /^'|'$/
					// See rest below
				}
			},
			'string': /"(?:[^"\\]|\\.)*"/,
			'variable': /\w+(?==)/,
			'punctuation': /^\[|\]$|,/,
			'operator': /=/,
			// The negative look-ahead prevents blank matches
			'attr-value': /(?!^\s+$).+/
		}
	};

	var asciidoc = Prism.languages.asciidoc = {
		'comment-block': {
			pattern: /^(\/{4,})$[\s\S]*?^\1/m,
			alias: 'comment'
		},
		'table': {
			pattern: /^\|={3,}(?:(?:\r?\n|\r(?!\n)).*)*?(?:\r?\n|\r)\|={3,}$/m,
			inside: {
				'specifiers': {
					pattern: /(?:(?:(?:\d+(?:\.\d+)?|\.\d+)[+*](?:[<^>](?:\.[<^>])?|\.[<^>])?|[<^>](?:\.[<^>])?|\.[<^>])[a-z]*|[a-z]+)(?=\|)/,
					alias: 'attr-value'
				},
				'punctuation': {
					pattern: /(^|[^\\])[|!]=*/,
					lookbehind: true
				}
				// See rest below
			}
		},

		'passthrough-block': {
			pattern: /^(\+{4,})$[\s\S]*?^\1$/m,
			inside: {
				'punctuation': /^\++|\++$/
				// See rest below
			}
		},
		// Literal blocks and listing blocks
		'literal-block': {
			pattern: /^(-{4,}|\.{4,})$[\s\S]*?^\1$/m,
			inside: {
				'punctuation': /^(?:-+|\.+)|(?:-+|\.+)$/
				// See rest below
			}
		},
		// Sidebar blocks, quote blocks, example blocks and open blocks
		'other-block': {
			pattern: /^(--|\*{4,}|_{4,}|={4,})$[\s\S]*?^\1$/m,
			inside: {
				'punctuation': /^(?:-+|\*+|_+|=+)|(?:-+|\*+|_+|=+)$/
				// See rest below
			}
		},

		// list-punctuation and list-label must appear before indented-block
		'list-punctuation': {
			pattern: /(^[ \t]*)(?:-|\*{1,5}|\.{1,5}|(?:[a-z]|\d+)\.|[xvi]+\))(?= )/im,
			lookbehind: true,
			alias: 'punctuation'
		},
		'list-label': {
			pattern: /(^[ \t]*)[a-z\d].+(?::{2,4}|;;)(?=\s)/im,
			lookbehind: true,
			alias: 'symbol'
		},
		'indented-block': {
			pattern: /((\r?\n|\r)\2)([ \t]+)\S.*(?:(?:\r?\n|\r)\3.+)*(?=\2{2}|$)/,
			lookbehind: true
		},

		'comment': /^\/\/.*/m,
		'title': {
			pattern: /^.+(?:\r?\n|\r)(?:={3,}|-{3,}|~{3,}|\^{3,}|\+{3,})$|^={1,5} .+|^\.(?![\s.]).*/m,
			alias: 'important',
			inside: {
				'punctuation': /^(?:\.|=+)|(?:=+|-+|~+|\^+|\++)$/
				// See rest below
			}
		},
		'attribute-entry': {
			pattern: /^:[^:\r\n]+:(?: .*?(?: \+(?:\r?\n|\r).*?)*)?$/m,
			alias: 'tag'
		},
		'attributes': attributes,
		'hr': {
			pattern: /^'{3,}$/m,
			alias: 'punctuation'
		},
		'page-break': {
			pattern: /^<{3,}$/m,
			alias: 'punctuation'
		},
		'admonition': {
			pattern: /^(?:CAUTION|IMPORTANT|NOTE|TIP|WARNING):/m,
			alias: 'keyword'
		},
		'callout': [
			{
				pattern: /(^[ \t]*)<?\d*>/m,
				lookbehind: true,
				alias: 'symbol'
			},
			{
				pattern: /<\d+>/,
				alias: 'symbol'
			}
		],
		'macro': {
			pattern: /\b[a-z\d][a-z\d-]*::?(?:[^\s\[\]]*\[(?:[^\]\\"']|(["'])(?:(?!\1)[^\\]|\\.)*\1|\\.)*\])/,
			inside: {
				'function': /^[a-z\d-]+(?=:)/,
				'punctuation': /^::?/,
				'attributes': {
					pattern: /(?:\[(?:[^\]\\"']|(["'])(?:(?!\1)[^\\]|\\.)*\1|\\.)*\])/,
					inside: attributes.inside
				}
			}
		},
		'inline': {
			/*
			The initial look-behind prevents the highlighting of escaped quoted text.

			Quoted text can be multi-line but cannot span an empty line.
			All quoted text can have attributes before [foobar, 'foobar', baz="bar"].

			First, we handle the constrained quotes.
			Those must be bounded by non-word chars and cannot have spaces between the delimiter and the first char.
			They are, in order: _emphasis_, ``double quotes'', `single quotes', `monospace`, 'emphasis', *strong*, +monospace+ and #unquoted#

			Then we handle the unconstrained quotes.
			Those do not have the restrictions of the constrained quotes.
			They are, in order: __emphasis__, **strong**, ++monospace++, +++passthrough+++, ##unquoted##, $$passthrough$$, ~subscript~, ^superscript^, {attribute-reference}, [[anchor]], [[[bibliography anchor]]], <<xref>>, (((indexes))) and ((indexes))
			 */
			pattern: /(^|[^\\])(?:(?:\B\[(?:[^\]\\"']|(["'])(?:(?!\2)[^\\]|\\.)*\2|\\.)*\])?(?:\b_(?!\s)(?: _|[^_\\\r\n]|\\.)+(?:(?:\r?\n|\r)(?: _|[^_\\\r\n]|\\.)+)*_\b|\B``(?!\s).+?(?:(?:\r?\n|\r).+?)*''\B|\B`(?!\s)(?:[^`'\s]|\s+\S)+['`]\B|\B(['*+#])(?!\s)(?: \3|(?!\3)[^\\\r\n]|\\.)+(?:(?:\r?\n|\r)(?: \3|(?!\3)[^\\\r\n]|\\.)+)*\3\B)|(?:\[(?:[^\]\\"']|(["'])(?:(?!\4)[^\\]|\\.)*\4|\\.)*\])?(?:(__|\*\*|\+\+\+?|##|\$\$|[~^]).+?(?:(?:\r?\n|\r).+?)*\5|\{[^}\r\n]+\}|\[\[\[?.+?(?:(?:\r?\n|\r).+?)*\]?\]\]|<<.+?(?:(?:\r?\n|\r).+?)*>>|\(\(\(?.+?(?:(?:\r?\n|\r).+?)*\)?\)\)))/m,
			lookbehind: true,
			inside: {
				'attributes': attributes,
				'url': {
					pattern: /^(?:\[\[\[?.+?\]?\]\]|<<.+?>>)$/,
					inside: {
						'punctuation': /^(?:\[\[\[?|<<)|(?:\]\]\]?|>>)$/
					}
				},
				'attribute-ref': {
					pattern: /^\{.+\}$/,
					inside: {
						'variable': {
							pattern: /(^\{)[a-z\d,+_-]+/,
							lookbehind: true
						},
						'operator': /^[=?!#%@$]|!(?=[:}])/,
						'punctuation': /^\{|\}$|::?/
					}
				},
				'italic': {
					pattern: /^(['_])[\s\S]+\1$/,
					inside: {
						'punctuation': /^(?:''?|__?)|(?:''?|__?)$/
					}
				},
				'bold': {
					pattern: /^\*[\s\S]+\*$/,
					inside: {
						punctuation: /^\*\*?|\*\*?$/
					}
				},
				'punctuation': /^(?:``?|\+{1,3}|##?|\$\$|[~^]|\(\(\(?)|(?:''?|\+{1,3}|##?|\$\$|[~^`]|\)?\)\))$/
			}
		},
		'replacement': {
			pattern: /\((?:C|R|TM)\)/,
			alias: 'builtin'
		},
		'entity': /&#?[\da-z]{1,8};/i,
		'line-continuation': {
			pattern: /(^| )\+$/m,
			lookbehind: true,
			alias: 'punctuation'
		}
	};


	// Allow some nesting. There is no recursion though, so cloning should not be needed.

	function copyFromAsciiDoc(keys) {
		keys = keys.split(' ');

		var o = {};
		for (var i = 0, l = keys.length; i < l; i++) {
			o[keys[i]] = asciidoc[keys[i]];
		}
		return o;
	}

	attributes.inside['interpreted'].inside.rest = copyFromAsciiDoc('macro inline replacement entity');

	asciidoc['passthrough-block'].inside.rest = copyFromAsciiDoc('macro');

	asciidoc['literal-block'].inside.rest = copyFromAsciiDoc('callout');

	asciidoc['table'].inside.rest = copyFromAsciiDoc('comment-block passthrough-block literal-block other-block list-punctuation indented-block comment title attribute-entry attributes hr page-break admonition list-label callout macro inline replacement entity line-continuation');

	asciidoc['other-block'].inside.rest = copyFromAsciiDoc('table list-punctuation indented-block comment attribute-entry attributes hr page-break admonition list-label macro inline replacement entity line-continuation');

	asciidoc['title'].inside.rest = copyFromAsciiDoc('macro inline replacement entity');


	// Plugin to make entity title show the real entity, idea by Roman Komarov
	Prism.hooks.add('wrap', function (env) {
		if (env.type === 'entity') {
			env.attributes['title'] = env.content.replace(/&amp;/, '&');
		}
	});

	Prism.languages.adoc = Prism.languages.asciidoc;
}(Prism));

(function (Prism) {

	/**
	 * Replaces all placeholders "<<n>>" of given pattern with the n-th replacement (zero based).
	 *
	 * Note: This is a simple text based replacement. Be careful when using backreferences!
	 *
	 * @param {string} pattern the given pattern.
	 * @param {string[]} replacements a list of replacement which can be inserted into the given pattern.
	 * @returns {string} the pattern with all placeholders replaced with their corresponding replacements.
	 * @example replace(/a<<0>>a/.source, [/b+/.source]) === /a(?:b+)a/.source
	 */
	function replace(pattern, replacements) {
		return pattern.replace(/<<(\d+)>>/g, function (m, index) {
			return '(?:' + replacements[+index] + ')';
		});
	}
	/**
	 * @param {string} pattern
	 * @param {string[]} replacements
	 * @param {string} [flags]
	 * @returns {RegExp}
	 */
	function re(pattern, replacements, flags) {
		return RegExp(replace(pattern, replacements), flags || '');
	}

	/**
	 * Creates a nested pattern where all occurrences of the string `<<self>>` are replaced with the pattern itself.
	 *
	 * @param {string} pattern
	 * @param {number} depthLog2
	 * @returns {string}
	 */
	function nested(pattern, depthLog2) {
		for (var i = 0; i < depthLog2; i++) {
			pattern = pattern.replace(/<<self>>/g, function () { return '(?:' + pattern + ')'; });
		}
		return pattern.replace(/<<self>>/g, '[^\\s\\S]');
	}

	// https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/
	var keywordKinds = {
		// keywords which represent a return or variable type
		type: 'bool byte char decimal double dynamic float int long object sbyte short string uint ulong ushort var void',
		// keywords which are used to declare a type
		typeDeclaration: 'class enum interface record struct',
		// contextual keywords
		// ("var" and "dynamic" are missing because they are used like types)
		contextual: 'add alias and ascending async await by descending from(?=\\s*(?:\\w|$)) get global group into init(?=\\s*;) join let nameof not notnull on or orderby partial remove select set unmanaged value when where with(?=\\s*{)',
		// all other keywords
		other: 'abstract as base break case catch checked const continue default delegate do else event explicit extern finally fixed for foreach goto if implicit in internal is lock namespace new null operator out override params private protected public readonly ref return sealed sizeof stackalloc static switch this throw try typeof unchecked unsafe using virtual volatile while yield'
	};

	// keywords
	function keywordsToPattern(words) {
		return '\\b(?:' + words.trim().replace(/ /g, '|') + ')\\b';
	}
	var typeDeclarationKeywords = keywordsToPattern(keywordKinds.typeDeclaration);
	var keywords = RegExp(keywordsToPattern(keywordKinds.type + ' ' + keywordKinds.typeDeclaration + ' ' + keywordKinds.contextual + ' ' + keywordKinds.other));
	var nonTypeKeywords = keywordsToPattern(keywordKinds.typeDeclaration + ' ' + keywordKinds.contextual + ' ' + keywordKinds.other);
	var nonContextualKeywords = keywordsToPattern(keywordKinds.type + ' ' + keywordKinds.typeDeclaration + ' ' + keywordKinds.other);

	// types
	var generic = nested(/<(?:[^<>;=+\-*/%&|^]|<<self>>)*>/.source, 2); // the idea behind the other forbidden characters is to prevent false positives. Same for tupleElement.
	var nestedRound = nested(/\((?:[^()]|<<self>>)*\)/.source, 2);
	var name = /@?\b[A-Za-z_]\w*\b/.source;
	var genericName = replace(/<<0>>(?:\s*<<1>>)?/.source, [name, generic]);
	var identifier = replace(/(?!<<0>>)<<1>>(?:\s*\.\s*<<1>>)*/.source, [nonTypeKeywords, genericName]);
	var array = /\[\s*(?:,\s*)*\]/.source;
	var typeExpressionWithoutTuple = replace(/<<0>>(?:\s*(?:\?\s*)?<<1>>)*(?:\s*\?)?/.source, [identifier, array]);
	var tupleElement = replace(/[^,()<>[\];=+\-*/%&|^]|<<0>>|<<1>>|<<2>>/.source, [generic, nestedRound, array]);
	var tuple = replace(/\(<<0>>+(?:,<<0>>+)+\)/.source, [tupleElement]);
	var typeExpression = replace(/(?:<<0>>|<<1>>)(?:\s*(?:\?\s*)?<<2>>)*(?:\s*\?)?/.source, [tuple, identifier, array]);

	var typeInside = {
		'keyword': keywords,
		'punctuation': /[<>()?,.:[\]]/
	};

	// strings & characters
	// https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/language-specification/lexical-structure#character-literals
	// https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/language-specification/lexical-structure#string-literals
	var character = /'(?:[^\r\n'\\]|\\.|\\[Uux][\da-fA-F]{1,8})'/.source; // simplified pattern
	var regularString = /"(?:\\.|[^\\"\r\n])*"/.source;
	var verbatimString = /@"(?:""|\\[\s\S]|[^\\"])*"(?!")/.source;


	Prism.languages.csharp = Prism.languages.extend('clike', {
		'string': [
			{
				pattern: re(/(^|[^$\\])<<0>>/.source, [verbatimString]),
				lookbehind: true,
				greedy: true
			},
			{
				pattern: re(/(^|[^@$\\])<<0>>/.source, [regularString]),
				lookbehind: true,
				greedy: true
			}
		],
		'class-name': [
			{
				// Using static
				// using static System.Math;
				pattern: re(/(\busing\s+static\s+)<<0>>(?=\s*;)/.source, [identifier]),
				lookbehind: true,
				inside: typeInside
			},
			{
				// Using alias (type)
				// using Project = PC.MyCompany.Project;
				pattern: re(/(\busing\s+<<0>>\s*=\s*)<<1>>(?=\s*;)/.source, [name, typeExpression]),
				lookbehind: true,
				inside: typeInside
			},
			{
				// Using alias (alias)
				// using Project = PC.MyCompany.Project;
				pattern: re(/(\busing\s+)<<0>>(?=\s*=)/.source, [name]),
				lookbehind: true
			},
			{
				// Type declarations
				// class Foo<A, B>
				// interface Foo<out A, B>
				pattern: re(/(\b<<0>>\s+)<<1>>/.source, [typeDeclarationKeywords, genericName]),
				lookbehind: true,
				inside: typeInside
			},
			{
				// Single catch exception declaration
				// catch(Foo)
				// (things like catch(Foo e) is covered by variable declaration)
				pattern: re(/(\bcatch\s*\(\s*)<<0>>/.source, [identifier]),
				lookbehind: true,
				inside: typeInside
			},
			{
				// Name of the type parameter of generic constraints
				// where Foo : class
				pattern: re(/(\bwhere\s+)<<0>>/.source, [name]),
				lookbehind: true
			},
			{
				// Casts and checks via as and is.
				// as Foo<A>, is Bar<B>
				// (things like if(a is Foo b) is covered by variable declaration)
				pattern: re(/(\b(?:is(?:\s+not)?|as)\s+)<<0>>/.source, [typeExpressionWithoutTuple]),
				lookbehind: true,
				inside: typeInside
			},
			{
				// Variable, field and parameter declaration
				// (Foo bar, Bar baz, Foo[,,] bay, Foo<Bar, FooBar<Bar>> bax)
				pattern: re(/\b<<0>>(?=\s+(?!<<1>>|with\s*\{)<<2>>(?:\s*[=,;:{)\]]|\s+(?:in|when)\b))/.source, [typeExpression, nonContextualKeywords, name]),
				inside: typeInside
			}
		],
		'keyword': keywords,
		// https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/language-specification/lexical-structure#literals
		'number': /(?:\b0(?:x[\da-f_]*[\da-f]|b[01_]*[01])|(?:\B\.\d+(?:_+\d+)*|\b\d+(?:_+\d+)*(?:\.\d+(?:_+\d+)*)?)(?:e[-+]?\d+(?:_+\d+)*)?)(?:[dflmu]|lu|ul)?\b/i,
		'operator': />>=?|<<=?|[-=]>|([-+&|])\1|~|\?\?=?|[-+*/%&|^!=<>]=?/,
		'punctuation': /\?\.?|::|[{}[\];(),.:]/
	});

	Prism.languages.insertBefore('csharp', 'number', {
		'range': {
			pattern: /\.\./,
			alias: 'operator'
		}
	});

	Prism.languages.insertBefore('csharp', 'punctuation', {
		'named-parameter': {
			pattern: re(/([(,]\s*)<<0>>(?=\s*:)/.source, [name]),
			lookbehind: true,
			alias: 'punctuation'
		}
	});

	Prism.languages.insertBefore('csharp', 'class-name', {
		'namespace': {
			// namespace Foo.Bar {}
			// using Foo.Bar;
			pattern: re(/(\b(?:namespace|using)\s+)<<0>>(?:\s*\.\s*<<0>>)*(?=\s*[;{])/.source, [name]),
			lookbehind: true,
			inside: {
				'punctuation': /\./
			}
		},
		'type-expression': {
			// default(Foo), typeof(Foo<Bar>), sizeof(int)
			pattern: re(/(\b(?:default|sizeof|typeof)\s*\(\s*(?!\s))(?:[^()\s]|\s(?!\s)|<<0>>)*(?=\s*\))/.source, [nestedRound]),
			lookbehind: true,
			alias: 'class-name',
			inside: typeInside
		},
		'return-type': {
			// Foo<Bar> ForBar(); Foo IFoo.Bar() => 0
			// int this[int index] => 0; T IReadOnlyList<T>.this[int index] => this[index];
			// int Foo => 0; int Foo { get; set } = 0;
			pattern: re(/<<0>>(?=\s+(?:<<1>>\s*(?:=>|[({]|\.\s*this\s*\[)|this\s*\[))/.source, [typeExpression, identifier]),
			inside: typeInside,
			alias: 'class-name'
		},
		'constructor-invocation': {
			// new List<Foo<Bar[]>> { }
			pattern: re(/(\bnew\s+)<<0>>(?=\s*[[({])/.source, [typeExpression]),
			lookbehind: true,
			inside: typeInside,
			alias: 'class-name'
		},
		/*'explicit-implementation': {
			// int IFoo<Foo>.Bar => 0; void IFoo<Foo<Foo>>.Foo<T>();
			pattern: replace(/\b<<0>>(?=\.<<1>>)/, className, methodOrPropertyDeclaration),
			inside: classNameInside,
			alias: 'class-name'
		},*/
		'generic-method': {
			// foo<Bar>()
			pattern: re(/<<0>>\s*<<1>>(?=\s*\()/.source, [name, generic]),
			inside: {
				'function': re(/^<<0>>/.source, [name]),
				'generic': {
					pattern: RegExp(generic),
					alias: 'class-name',
					inside: typeInside
				}
			}
		},
		'type-list': {
			// The list of types inherited or of generic constraints
			// class Foo<F> : Bar, IList<FooBar>
			// where F : Bar, IList<int>
			pattern: re(
				/\b((?:<<0>>\s+<<1>>|record\s+<<1>>\s*<<5>>|where\s+<<2>>)\s*:\s*)(?:<<3>>|<<4>>|<<1>>\s*<<5>>|<<6>>)(?:\s*,\s*(?:<<3>>|<<4>>|<<6>>))*(?=\s*(?:where|[{;]|=>|$))/.source,
				[typeDeclarationKeywords, genericName, name, typeExpression, keywords.source, nestedRound, /\bnew\s*\(\s*\)/.source]
			),
			lookbehind: true,
			inside: {
				'record-arguments': {
					pattern: re(/(^(?!new\s*\()<<0>>\s*)<<1>>/.source, [genericName, nestedRound]),
					lookbehind: true,
					greedy: true,
					inside: Prism.languages.csharp
				},
				'keyword': keywords,
				'class-name': {
					pattern: RegExp(typeExpression),
					greedy: true,
					inside: typeInside
				},
				'punctuation': /[,()]/
			}
		},
		'preprocessor': {
			pattern: /(^[\t ]*)#.*/m,
			lookbehind: true,
			alias: 'property',
			inside: {
				// highlight preprocessor directives as keywords
				'directive': {
					pattern: /(#)\b(?:define|elif|else|endif|endregion|error|if|line|nullable|pragma|region|undef|warning)\b/,
					lookbehind: true,
					alias: 'keyword'
				}
			}
		}
	});

	// attributes
	var regularStringOrCharacter = regularString + '|' + character;
	var regularStringCharacterOrComment = replace(/\/(?![*/])|\/\/[^\r\n]*[\r\n]|\/\*(?:[^*]|\*(?!\/))*\*\/|<<0>>/.source, [regularStringOrCharacter]);
	var roundExpression = nested(replace(/[^"'/()]|<<0>>|\(<<self>>*\)/.source, [regularStringCharacterOrComment]), 2);

	// https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/attributes/#attribute-targets
	var attrTarget = /\b(?:assembly|event|field|method|module|param|property|return|type)\b/.source;
	var attr = replace(/<<0>>(?:\s*\(<<1>>*\))?/.source, [identifier, roundExpression]);

	Prism.languages.insertBefore('csharp', 'class-name', {
		'attribute': {
			// Attributes
			// [Foo], [Foo(1), Bar(2, Prop = "foo")], [return: Foo(1), Bar(2)], [assembly: Foo(Bar)]
			pattern: re(/((?:^|[^\s\w>)?])\s*\[\s*)(?:<<0>>\s*:\s*)?<<1>>(?:\s*,\s*<<1>>)*(?=\s*\])/.source, [attrTarget, attr]),
			lookbehind: true,
			greedy: true,
			inside: {
				'target': {
					pattern: re(/^<<0>>(?=\s*:)/.source, [attrTarget]),
					alias: 'keyword'
				},
				'attribute-arguments': {
					pattern: re(/\(<<0>>*\)/.source, [roundExpression]),
					inside: Prism.languages.csharp
				},
				'class-name': {
					pattern: RegExp(identifier),
					inside: {
						'punctuation': /\./
					}
				},
				'punctuation': /[:,]/
			}
		}
	});


	// string interpolation
	var formatString = /:[^}\r\n]+/.source;
	// multi line
	var mInterpolationRound = nested(replace(/[^"'/()]|<<0>>|\(<<self>>*\)/.source, [regularStringCharacterOrComment]), 2);
	var mInterpolation = replace(/\{(?!\{)(?:(?![}:])<<0>>)*<<1>>?\}/.source, [mInterpolationRound, formatString]);
	// single line
	var sInterpolationRound = nested(replace(/[^"'/()]|\/(?!\*)|\/\*(?:[^*]|\*(?!\/))*\*\/|<<0>>|\(<<self>>*\)/.source, [regularStringOrCharacter]), 2);
	var sInterpolation = replace(/\{(?!\{)(?:(?![}:])<<0>>)*<<1>>?\}/.source, [sInterpolationRound, formatString]);

	function createInterpolationInside(interpolation, interpolationRound) {
		return {
			'interpolation': {
				pattern: re(/((?:^|[^{])(?:\{\{)*)<<0>>/.source, [interpolation]),
				lookbehind: true,
				inside: {
					'format-string': {
						pattern: re(/(^\{(?:(?![}:])<<0>>)*)<<1>>(?=\}$)/.source, [interpolationRound, formatString]),
						lookbehind: true,
						inside: {
							'punctuation': /^:/
						}
					},
					'punctuation': /^\{|\}$/,
					'expression': {
						pattern: /[\s\S]+/,
						alias: 'language-csharp',
						inside: Prism.languages.csharp
					}
				}
			},
			'string': /[\s\S]+/
		};
	}

	Prism.languages.insertBefore('csharp', 'string', {
		'interpolation-string': [
			{
				pattern: re(/(^|[^\\])(?:\$@|@\$)"(?:""|\\[\s\S]|\{\{|<<0>>|[^\\{"])*"/.source, [mInterpolation]),
				lookbehind: true,
				greedy: true,
				inside: createInterpolationInside(mInterpolation, mInterpolationRound),
			},
			{
				pattern: re(/(^|[^@\\])\$"(?:\\.|\{\{|<<0>>|[^\\"{])*"/.source, [sInterpolation]),
				lookbehind: true,
				greedy: true,
				inside: createInterpolationInside(sInterpolation, sInterpolationRound),
			}
		],
		'char': {
			pattern: RegExp(character),
			greedy: true
		}
	});

	Prism.languages.dotnet = Prism.languages.cs = Prism.languages.csharp;

}(Prism));

Prism.languages.aspnet = Prism.languages.extend('markup', {
	'page-directive': {
		pattern: /<%\s*@.*%>/,
		alias: 'tag',
		inside: {
			'page-directive': {
				pattern: /<%\s*@\s*(?:Assembly|Control|Implements|Import|Master(?:Type)?|OutputCache|Page|PreviousPageType|Reference|Register)?|%>/i,
				alias: 'tag'
			},
			rest: Prism.languages.markup.tag.inside
		}
	},
	'directive': {
		pattern: /<%.*%>/,
		alias: 'tag',
		inside: {
			'directive': {
				pattern: /<%\s*?[$=%#:]{0,2}|%>/,
				alias: 'tag'
			},
			rest: Prism.languages.csharp
		}
	}
});
// Regexp copied from prism-markup, with a negative look-ahead added
Prism.languages.aspnet.tag.pattern = /<(?!%)\/?[^\s>\/]+(?:\s+[^\s>\/=]+(?:=(?:("|')(?:\\[\s\S]|(?!\1)[^\\])*\1|[^\s'">=]+))?)*\s*\/?>/;

// match directives of attribute value foo="<% Bar %>"
Prism.languages.insertBefore('inside', 'punctuation', {
	'directive': Prism.languages.aspnet['directive']
}, Prism.languages.aspnet.tag.inside['attr-value']);

Prism.languages.insertBefore('aspnet', 'comment', {
	'asp-comment': {
		pattern: /<%--[\s\S]*?--%>/,
		alias: ['asp', 'comment']
	}
});

// script runat="server" contains csharp, not javascript
Prism.languages.insertBefore('aspnet', Prism.languages.javascript ? 'script' : 'tag', {
	'asp-script': {
		pattern: /(<script(?=.*runat=['"]?server\b)[^>]*>)[\s\S]*?(?=<\/script>)/i,
		lookbehind: true,
		alias: ['asp', 'script'],
		inside: Prism.languages.csharp || {}
	}
});

Prism.languages.awk = {
	'hashbang': {
		pattern: /^#!.*/,
		greedy: true,
		alias: 'comment'
	},
	'comment': {
		pattern: /#.*/,
		greedy: true
	},
	'string': {
		pattern: /(^|[^\\])"(?:[^\\"\r\n]|\\.)*"/,
		lookbehind: true,
		greedy: true
	},
	'regex': {
		pattern: /((?:^|[^\w\s)])\s*)\/(?:[^\/\\\r\n]|\\.)*\//,
		lookbehind: true,
		greedy: true
	},

	'variable': /\$\w+/,
	'keyword': /\b(?:BEGIN|BEGINFILE|END|ENDFILE|break|case|continue|default|delete|do|else|exit|for|function|getline|if|in|next|nextfile|printf?|return|switch|while)\b|@(?:include|load)\b/,

	'function': /\b[a-z_]\w*(?=\s*\()/i,
	'number': /\b(?:\d+(?:\.\d+)?(?:e[+-]?\d+)?|0x[a-fA-F0-9]+)\b/,

	'operator': /--|\+\+|!?~|>&|>>|<<|(?:\*\*|[<>!=+\-*/%^])=?|&&|\|[|&]|[?:]/,
	'punctuation': /[()[\]{},;]/
};

Prism.languages.gawk = Prism.languages.awk;

(function (Prism) {
	// $ set | grep '^[A-Z][^[:space:]]*=' | cut -d= -f1 | tr '\n' '|'
	// + LC_ALL, RANDOM, REPLY, SECONDS.
	// + make sure PS1..4 are here as they are not always set,
	// - some useless things.
	var envVars = '\\b(?:BASH|BASHOPTS|BASH_ALIASES|BASH_ARGC|BASH_ARGV|BASH_CMDS|BASH_COMPLETION_COMPAT_DIR|BASH_LINENO|BASH_REMATCH|BASH_SOURCE|BASH_VERSINFO|BASH_VERSION|COLORTERM|COLUMNS|COMP_WORDBREAKS|DBUS_SESSION_BUS_ADDRESS|DEFAULTS_PATH|DESKTOP_SESSION|DIRSTACK|DISPLAY|EUID|GDMSESSION|GDM_LANG|GNOME_KEYRING_CONTROL|GNOME_KEYRING_PID|GPG_AGENT_INFO|GROUPS|HISTCONTROL|HISTFILE|HISTFILESIZE|HISTSIZE|HOME|HOSTNAME|HOSTTYPE|IFS|INSTANCE|JOB|LANG|LANGUAGE|LC_ADDRESS|LC_ALL|LC_IDENTIFICATION|LC_MEASUREMENT|LC_MONETARY|LC_NAME|LC_NUMERIC|LC_PAPER|LC_TELEPHONE|LC_TIME|LESSCLOSE|LESSOPEN|LINES|LOGNAME|LS_COLORS|MACHTYPE|MAILCHECK|MANDATORY_PATH|NO_AT_BRIDGE|OLDPWD|OPTERR|OPTIND|ORBIT_SOCKETDIR|OSTYPE|PAPERSIZE|PATH|PIPESTATUS|PPID|PS1|PS2|PS3|PS4|PWD|RANDOM|REPLY|SECONDS|SELINUX_INIT|SESSION|SESSIONTYPE|SESSION_MANAGER|SHELL|SHELLOPTS|SHLVL|SSH_AUTH_SOCK|TERM|UID|UPSTART_EVENTS|UPSTART_INSTANCE|UPSTART_JOB|UPSTART_SESSION|USER|WINDOWID|XAUTHORITY|XDG_CONFIG_DIRS|XDG_CURRENT_DESKTOP|XDG_DATA_DIRS|XDG_GREETER_DATA_DIR|XDG_MENU_PREFIX|XDG_RUNTIME_DIR|XDG_SEAT|XDG_SEAT_PATH|XDG_SESSION_DESKTOP|XDG_SESSION_ID|XDG_SESSION_PATH|XDG_SESSION_TYPE|XDG_VTNR|XMODIFIERS)\\b';

	var commandAfterHeredoc = {
		pattern: /(^(["']?)\w+\2)[ \t]+\S.*/,
		lookbehind: true,
		alias: 'punctuation', // this looks reasonably well in all themes
		inside: null // see below
	};

	var insideString = {
		'bash': commandAfterHeredoc,
		'environment': {
			pattern: RegExp('\\$' + envVars),
			alias: 'constant'
		},
		'variable': [
			// [0]: Arithmetic Environment
			{
				pattern: /\$?\(\([\s\S]+?\)\)/,
				greedy: true,
				inside: {
					// If there is a $ sign at the beginning highlight $(( and )) as variable
					'variable': [
						{
							pattern: /(^\$\(\([\s\S]+)\)\)/,
							lookbehind: true
						},
						/^\$\(\(/
					],
					'number': /\b0x[\dA-Fa-f]+\b|(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:[Ee]-?\d+)?/,
					// Operators according to https://www.gnu.org/software/bash/manual/bashref.html#Shell-Arithmetic
					'operator': /--|\+\+|\*\*=?|<<=?|>>=?|&&|\|\||[=!+\-*/%<>^&|]=?|[?~:]/,
					// If there is no $ sign at the beginning highlight (( and )) as punctuation
					'punctuation': /\(\(?|\)\)?|,|;/
				}
			},
			// [1]: Command Substitution
			{
				pattern: /\$\((?:\([^)]+\)|[^()])+\)|`[^`]+`/,
				greedy: true,
				inside: {
					'variable': /^\$\(|^`|\)$|`$/
				}
			},
			// [2]: Brace expansion
			{
				pattern: /\$\{[^}]+\}/,
				greedy: true,
				inside: {
					'operator': /:[-=?+]?|[!\/]|##?|%%?|\^\^?|,,?/,
					'punctuation': /[\[\]]/,
					'environment': {
						pattern: RegExp('(\\{)' + envVars),
						lookbehind: true,
						alias: 'constant'
					}
				}
			},
			/\$(?:\w+|[#?*!@$])/
		],
		// Escape sequences from echo and printf's manuals, and escaped quotes.
		'entity': /\\(?:[abceEfnrtv\\"]|O?[0-7]{1,3}|U[0-9a-fA-F]{8}|u[0-9a-fA-F]{4}|x[0-9a-fA-F]{1,2})/
	};

	Prism.languages.bash = {
		'shebang': {
			pattern: /^#!\s*\/.*/,
			alias: 'important'
		},
		'comment': {
			pattern: /(^|[^"{\\$])#.*/,
			lookbehind: true
		},
		'function-name': [
			// a) function foo {
			// b) foo() {
			// c) function foo() {
			// but not “foo {”
			{
				// a) and c)
				pattern: /(\bfunction\s+)[\w-]+(?=(?:\s*\(?:\s*\))?\s*\{)/,
				lookbehind: true,
				alias: 'function'
			},
			{
				// b)
				pattern: /\b[\w-]+(?=\s*\(\s*\)\s*\{)/,
				alias: 'function'
			}
		],
		// Highlight variable names as variables in for and select beginnings.
		'for-or-select': {
			pattern: /(\b(?:for|select)\s+)\w+(?=\s+in\s)/,
			alias: 'variable',
			lookbehind: true
		},
		// Highlight variable names as variables in the left-hand part
		// of assignments (“=” and “+=”).
		'assign-left': {
			pattern: /(^|[\s;|&]|[<>]\()\w+(?:\.\w+)*(?=\+?=)/,
			inside: {
				'environment': {
					pattern: RegExp('(^|[\\s;|&]|[<>]\\()' + envVars),
					lookbehind: true,
					alias: 'constant'
				}
			},
			alias: 'variable',
			lookbehind: true
		},
		// Highlight parameter names as variables
		'parameter': {
			pattern: /(^|\s)-{1,2}(?:\w+:[+-]?)?\w+(?:\.\w+)*(?=[=\s]|$)/,
			alias: 'variable',
			lookbehind: true
		},
		'string': [
			// Support for Here-documents https://en.wikipedia.org/wiki/Here_document
			{
				pattern: /((?:^|[^<])<<-?\s*)(\w+)\s[\s\S]*?(?:\r?\n|\r)\2/,
				lookbehind: true,
				greedy: true,
				inside: insideString
			},
			// Here-document with quotes around the tag
			// → No expansion (so no “inside”).
			{
				pattern: /((?:^|[^<])<<-?\s*)(["'])(\w+)\2\s[\s\S]*?(?:\r?\n|\r)\3/,
				lookbehind: true,
				greedy: true,
				inside: {
					'bash': commandAfterHeredoc
				}
			},
			// “Normal” string
			{
				// https://www.gnu.org/software/bash/manual/html_node/Double-Quotes.html
				pattern: /(^|[^\\](?:\\\\)*)"(?:\\[\s\S]|\$\([^)]+\)|\$(?!\()|`[^`]+`|[^"\\`$])*"/,
				lookbehind: true,
				greedy: true,
				inside: insideString
			},
			{
				// https://www.gnu.org/software/bash/manual/html_node/Single-Quotes.html
				pattern: /(^|[^$\\])'[^']*'/,
				lookbehind: true,
				greedy: true
			},
			{
				// https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html
				pattern: /\$'(?:[^'\\]|\\[\s\S])*'/,
				greedy: true,
				inside: {
					'entity': insideString.entity
				}
			}
		],
		'environment': {
			pattern: RegExp('\\$?' + envVars),
			alias: 'constant'
		},
		'variable': insideString.variable,
		'function': {
			pattern: /(^|[\s;|&]|[<>]\()(?:add|apropos|apt|apt-cache|apt-get|aptitude|aspell|automysqlbackup|awk|basename|bash|bc|bconsole|bg|bzip2|cal|cargo|cat|cfdisk|chgrp|chkconfig|chmod|chown|chroot|cksum|clear|cmp|column|comm|composer|cp|cron|crontab|csplit|curl|cut|date|dc|dd|ddrescue|debootstrap|df|diff|diff3|dig|dir|dircolors|dirname|dirs|dmesg|docker|docker-compose|du|egrep|eject|env|ethtool|expand|expect|expr|fdformat|fdisk|fg|fgrep|file|find|fmt|fold|format|free|fsck|ftp|fuser|gawk|git|gparted|grep|groupadd|groupdel|groupmod|groups|grub-mkconfig|gzip|halt|head|hg|history|host|hostname|htop|iconv|id|ifconfig|ifdown|ifup|import|install|ip|java|jobs|join|kill|killall|less|link|ln|locate|logname|logrotate|look|lpc|lpr|lprint|lprintd|lprintq|lprm|ls|lsof|lynx|make|man|mc|mdadm|mkconfig|mkdir|mke2fs|mkfifo|mkfs|mkisofs|mknod|mkswap|mmv|more|most|mount|mtools|mtr|mutt|mv|nano|nc|netstat|nice|nl|node|nohup|notify-send|npm|nslookup|op|open|parted|passwd|paste|pathchk|ping|pkill|pnpm|podman|podman-compose|popd|pr|printcap|printenv|ps|pushd|pv|quota|quotacheck|quotactl|ram|rar|rcp|reboot|remsync|rename|renice|rev|rm|rmdir|rpm|rsync|scp|screen|sdiff|sed|sendmail|seq|service|sftp|sh|shellcheck|shuf|shutdown|sleep|slocate|sort|split|ssh|stat|strace|su|sudo|sum|suspend|swapon|sync|sysctl|tac|tail|tar|tee|time|timeout|top|touch|tr|traceroute|tsort|tty|umount|uname|unexpand|uniq|units|unrar|unshar|unzip|update-grub|uptime|useradd|userdel|usermod|users|uudecode|uuencode|v|vcpkg|vdir|vi|vim|virsh|vmstat|wait|watch|wc|wget|whereis|which|who|whoami|write|xargs|xdg-open|yarn|yes|zenity|zip|zsh|zypper)(?=$|[)\s;|&])/,
			lookbehind: true
		},
		'keyword': {
			pattern: /(^|[\s;|&]|[<>]\()(?:case|do|done|elif|else|esac|fi|for|function|if|in|select|then|until|while)(?=$|[)\s;|&])/,
			lookbehind: true
		},
		// https://www.gnu.org/software/bash/manual/html_node/Shell-Builtin-Commands.html
		'builtin': {
			pattern: /(^|[\s;|&]|[<>]\()(?:\.|:|alias|bind|break|builtin|caller|cd|command|continue|declare|echo|enable|eval|exec|exit|export|getopts|hash|help|let|local|logout|mapfile|printf|pwd|read|readarray|readonly|return|set|shift|shopt|source|test|times|trap|type|typeset|ulimit|umask|unalias|unset)(?=$|[)\s;|&])/,
			lookbehind: true,
			// Alias added to make those easier to distinguish from strings.
			alias: 'class-name'
		},
		'boolean': {
			pattern: /(^|[\s;|&]|[<>]\()(?:false|true)(?=$|[)\s;|&])/,
			lookbehind: true
		},
		'file-descriptor': {
			pattern: /\B&\d\b/,
			alias: 'important'
		},
		'operator': {
			// Lots of redirections here, but not just that.
			pattern: /\d?<>|>\||\+=|=[=~]?|!=?|<<[<-]?|[&\d]?>>|\d[<>]&?|[<>][&=]?|&[>&]?|\|[&|]?/,
			inside: {
				'file-descriptor': {
					pattern: /^\d/,
					alias: 'important'
				}
			}
		},
		'punctuation': /\$?\(\(?|\)\)?|\.\.|[{}[\];\\]/,
		'number': {
			pattern: /(^|\s)(?:[1-9]\d*|0)(?:[.,]\d+)?\b/,
			lookbehind: true
		}
	};

	commandAfterHeredoc.inside = Prism.languages.bash;

	/* Patterns in command substitution. */
	var toBeCopied = [
		'comment',
		'function-name',
		'for-or-select',
		'assign-left',
		'parameter',
		'string',
		'environment',
		'function',
		'keyword',
		'builtin',
		'boolean',
		'file-descriptor',
		'operator',
		'punctuation',
		'number'
	];
	var inside = insideString.variable[1].inside;
	for (var i = 0; i < toBeCopied.length; i++) {
		inside[toBeCopied[i]] = Prism.languages.bash[toBeCopied[i]];
	}

	Prism.languages.sh = Prism.languages.bash;
	Prism.languages.shell = Prism.languages.bash;
}(Prism));

Prism.languages.basic = {
	'comment': {
		pattern: /(?:!|REM\b).+/i,
		inside: {
			'keyword': /^REM/i
		}
	},
	'string': {
		pattern: /"(?:""|[!#$%&'()*,\/:;<=>?^\w +\-.])*"/,
		greedy: true
	},
	'number': /(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:E[+-]?\d+)?/i,
	'keyword': /\b(?:AS|BEEP|BLOAD|BSAVE|CALL(?: ABSOLUTE)?|CASE|CHAIN|CHDIR|CLEAR|CLOSE|CLS|COM|COMMON|CONST|DATA|DECLARE|DEF(?: FN| SEG|DBL|INT|LNG|SNG|STR)|DIM|DO|DOUBLE|ELSE|ELSEIF|END|ENVIRON|ERASE|ERROR|EXIT|FIELD|FILES|FOR|FUNCTION|GET|GOSUB|GOTO|IF|INPUT|INTEGER|IOCTL|KEY|KILL|LINE INPUT|LOCATE|LOCK|LONG|LOOP|LSET|MKDIR|NAME|NEXT|OFF|ON(?: COM| ERROR| KEY| TIMER)?|OPEN|OPTION BASE|OUT|POKE|PUT|READ|REDIM|REM|RESTORE|RESUME|RETURN|RMDIR|RSET|RUN|SELECT CASE|SHARED|SHELL|SINGLE|SLEEP|STATIC|STEP|STOP|STRING|SUB|SWAP|SYSTEM|THEN|TIMER|TO|TROFF|TRON|TYPE|UNLOCK|UNTIL|USING|VIEW PRINT|WAIT|WEND|WHILE|WRITE)(?:\$|\b)/i,
	'function': /\b(?:ABS|ACCESS|ACOS|ANGLE|AREA|ARITHMETIC|ARRAY|ASIN|ASK|AT|ATN|BASE|BEGIN|BREAK|CAUSE|CEIL|CHR|CLIP|COLLATE|COLOR|CON|COS|COSH|COT|CSC|DATE|DATUM|DEBUG|DECIMAL|DEF|DEG|DEGREES|DELETE|DET|DEVICE|DISPLAY|DOT|ELAPSED|EPS|ERASABLE|EXLINE|EXP|EXTERNAL|EXTYPE|FILETYPE|FIXED|FP|GO|GRAPH|HANDLER|IDN|IMAGE|IN|INT|INTERNAL|IP|IS|KEYED|LBOUND|LCASE|LEFT|LEN|LENGTH|LET|LINE|LINES|LOG|LOG10|LOG2|LTRIM|MARGIN|MAT|MAX|MAXNUM|MID|MIN|MISSING|MOD|NATIVE|NUL|NUMERIC|OF|OPTION|ORD|ORGANIZATION|OUTIN|OUTPUT|PI|POINT|POINTER|POINTS|POS|PRINT|PROGRAM|PROMPT|RAD|RADIANS|RANDOMIZE|RECORD|RECSIZE|RECTYPE|RELATIVE|REMAINDER|REPEAT|REST|RETRY|REWRITE|RIGHT|RND|ROUND|RTRIM|SAME|SEC|SELECT|SEQUENTIAL|SET|SETTER|SGN|SIN|SINH|SIZE|SKIP|SQR|STANDARD|STATUS|STR|STREAM|STYLE|TAB|TAN|TANH|TEMPLATE|TEXT|THERE|TIME|TIMEOUT|TRACE|TRANSFORM|TRUNCATE|UBOUND|UCASE|USE|VAL|VARIABLE|VIEWPORT|WHEN|WINDOW|WITH|ZER|ZONEWIDTH)(?:\$|\b)/i,
	'operator': /<[=>]?|>=?|[+\-*\/^=&]|\b(?:AND|EQV|IMP|NOT|OR|XOR)\b/i,
	'punctuation': /[,;:()]/
};

(function (Prism) {
	var variable = /%%?[~:\w]+%?|!\S+!/;
	var parameter = {
		pattern: /\/[a-z?]+(?=[ :]|$):?|-[a-z]\b|--[a-z-]+\b/im,
		alias: 'attr-name',
		inside: {
			'punctuation': /:/
		}
	};
	var string = /"(?:[\\"]"|[^"])*"(?!")/;
	var number = /(?:\b|-)\d+\b/;

	Prism.languages.batch = {
		'comment': [
			/^::.*/m,
			{
				pattern: /((?:^|[&(])[ \t]*)rem\b(?:[^^&)\r\n]|\^(?:\r\n|[\s\S]))*/im,
				lookbehind: true
			}
		],
		'label': {
			pattern: /^:.*/m,
			alias: 'property'
		},
		'command': [
			{
				// FOR command
				pattern: /((?:^|[&(])[ \t]*)for(?: \/[a-z?](?:[ :](?:"[^"]*"|[^\s"/]\S*))?)* \S+ in \([^)]+\) do/im,
				lookbehind: true,
				inside: {
					'keyword': /\b(?:do|in)\b|^for\b/i,
					'string': string,
					'parameter': parameter,
					'variable': variable,
					'number': number,
					'punctuation': /[()',]/
				}
			},
			{
				// IF command
				pattern: /((?:^|[&(])[ \t]*)if(?: \/[a-z?](?:[ :](?:"[^"]*"|[^\s"/]\S*))?)* (?:not )?(?:cmdextversion \d+|defined \w+|errorlevel \d+|exist \S+|(?:"[^"]*"|(?!")(?:(?!==)\S)+)?(?:==| (?:equ|geq|gtr|leq|lss|neq) )(?:"[^"]*"|[^\s"]\S*))/im,
				lookbehind: true,
				inside: {
					'keyword': /\b(?:cmdextversion|defined|errorlevel|exist|not)\b|^if\b/i,
					'string': string,
					'parameter': parameter,
					'variable': variable,
					'number': number,
					'operator': /\^|==|\b(?:equ|geq|gtr|leq|lss|neq)\b/i
				}
			},
			{
				// ELSE command
				pattern: /((?:^|[&()])[ \t]*)else\b/im,
				lookbehind: true,
				inside: {
					'keyword': /^else\b/i
				}
			},
			{
				// SET command
				pattern: /((?:^|[&(])[ \t]*)set(?: \/[a-z](?:[ :](?:"[^"]*"|[^\s"/]\S*))?)* (?:[^^&)\r\n]|\^(?:\r\n|[\s\S]))*/im,
				lookbehind: true,
				inside: {
					'keyword': /^set\b/i,
					'string': string,
					'parameter': parameter,
					'variable': [
						variable,
						/\w+(?=(?:[*\/%+\-&^|]|<<|>>)?=)/
					],
					'number': number,
					'operator': /[*\/%+\-&^|]=?|<<=?|>>=?|[!~_=]/,
					'punctuation': /[()',]/
				}
			},
			{
				// Other commands
				pattern: /((?:^|[&(])[ \t]*@?)\w+\b(?:"(?:[\\"]"|[^"])*"(?!")|[^"^&)\r\n]|\^(?:\r\n|[\s\S]))*/m,
				lookbehind: true,
				inside: {
					'keyword': /^\w+\b/,
					'string': string,
					'parameter': parameter,
					'label': {
						pattern: /(^\s*):\S+/m,
						lookbehind: true,
						alias: 'property'
					},
					'variable': variable,
					'number': number,
					'operator': /\^/
				}
			}
		],
		'operator': /[&@]/,
		'punctuation': /[()']/
	};
}(Prism));

Prism.languages.bison = Prism.languages.extend('c', {});

Prism.languages.insertBefore('bison', 'comment', {
	'bison': {
		// This should match all the beginning of the file
		// including the prologue(s), the bison declarations and
		// the grammar rules.
		pattern: /^(?:[^%]|%(?!%))*%%[\s\S]*?%%/,
		inside: {
			'c': {
				// Allow for one level of nested braces
				pattern: /%\{[\s\S]*?%\}|\{(?:\{[^}]*\}|[^{}])*\}/,
				inside: {
					'delimiter': {
						pattern: /^%?\{|%?\}$/,
						alias: 'punctuation'
					},
					'bison-variable': {
						pattern: /[$@](?:<[^\s>]+>)?[\w$]+/,
						alias: 'variable',
						inside: {
							'punctuation': /<|>/
						}
					},
					rest: Prism.languages.c
				}
			},
			'comment': Prism.languages.c.comment,
			'string': Prism.languages.c.string,
			'property': /\S+(?=:)/,
			'keyword': /%\w+/,
			'number': {
				pattern: /(^|[^@])\b(?:0x[\da-f]+|\d+)/i,
				lookbehind: true
			},
			'punctuation': /%[%?]|[|:;\[\]<>]/
		}
	}
});

Prism.languages.bnf = {
	'string': {
		pattern: /"[^\r\n"]*"|'[^\r\n']*'/
	},
	'definition': {
		pattern: /<[^<>\r\n\t]+>(?=\s*::=)/,
		alias: ['rule', 'keyword'],
		inside: {
			'punctuation': /^<|>$/
		}
	},
	'rule': {
		pattern: /<[^<>\r\n\t]+>/,
		inside: {
			'punctuation': /^<|>$/
		}
	},
	'operator': /::=|[|()[\]{}*+?]|\.{3}/
};

Prism.languages.rbnf = Prism.languages.bnf;

// Copied from https://github.com/jeluard/prism-clojure
Prism.languages.clojure = {
	'comment': {
		pattern: /;.*/,
		greedy: true
	},
	'string': {
		pattern: /"(?:[^"\\]|\\.)*"/,
		greedy: true
	},
	'char': /\\\w+/,
	'symbol': {
		pattern: /(^|[\s()\[\]{},])::?[\w*+!?'<>=/.-]+/,
		lookbehind: true
	},
	'keyword': {
		pattern: /(\()(?:-|->|->>|\.|\.\.|\*|\/|\+|<|<=|=|==|>|>=|accessor|agent|agent-errors|aget|alength|all-ns|alter|and|append-child|apply|array-map|aset|aset-boolean|aset-byte|aset-char|aset-double|aset-float|aset-int|aset-long|aset-short|assert|assoc|await|await-for|bean|binding|bit-and|bit-not|bit-or|bit-shift-left|bit-shift-right|bit-xor|boolean|branch\?|butlast|byte|cast|char|children|class|clear-agent-errors|comment|commute|comp|comparator|complement|concat|cond|conj|cons|constantly|construct-proxy|contains\?|count|create-ns|create-struct|cycle|dec|declare|def|def-|definline|definterface|defmacro|defmethod|defmulti|defn|defn-|defonce|defproject|defprotocol|defrecord|defstruct|deftype|deref|difference|disj|dissoc|distinct|do|doall|doc|dorun|doseq|dosync|dotimes|doto|double|down|drop|drop-while|edit|end\?|ensure|eval|every\?|false\?|ffirst|file-seq|filter|find|find-doc|find-ns|find-var|first|float|flush|fn|fnseq|for|frest|gensym|get|get-proxy-class|hash-map|hash-set|identical\?|identity|if|if-let|if-not|import|in-ns|inc|index|insert-child|insert-left|insert-right|inspect-table|inspect-tree|instance\?|int|interleave|intersection|into|into-array|iterate|join|key|keys|keyword|keyword\?|last|lazy-cat|lazy-cons|left|lefts|let|line-seq|list|list\*|load|load-file|locking|long|loop|macroexpand|macroexpand-1|make-array|make-node|map|map-invert|map\?|mapcat|max|max-key|memfn|merge|merge-with|meta|min|min-key|monitor-enter|name|namespace|neg\?|new|newline|next|nil\?|node|not|not-any\?|not-every\?|not=|ns|ns-imports|ns-interns|ns-map|ns-name|ns-publics|ns-refers|ns-resolve|ns-unmap|nth|nthrest|or|parse|partial|path|peek|pop|pos\?|pr|pr-str|print|print-str|println|println-str|prn|prn-str|project|proxy|proxy-mappings|quot|quote|rand|rand-int|range|re-find|re-groups|re-matcher|re-matches|re-pattern|re-seq|read|read-line|recur|reduce|ref|ref-set|refer|rem|remove|remove-method|remove-ns|rename|rename-keys|repeat|replace|replicate|resolve|rest|resultset-seq|reverse|rfirst|right|rights|root|rrest|rseq|second|select|select-keys|send|send-off|seq|seq-zip|seq\?|set|set!|short|slurp|some|sort|sort-by|sorted-map|sorted-map-by|sorted-set|special-symbol\?|split-at|split-with|str|string\?|struct|struct-map|subs|subvec|symbol|symbol\?|sync|take|take-nth|take-while|test|throw|time|to-array|to-array-2d|tree-seq|true\?|try|union|up|update-proxy|val|vals|var|var-get|var-set|var\?|vector|vector-zip|vector\?|when|when-first|when-let|when-not|with-local-vars|with-meta|with-open|with-out-str|xml-seq|xml-zip|zero\?|zipmap|zipper)(?=[\s)]|$)/,
		lookbehind: true
	},
	'boolean': /\b(?:false|nil|true)\b/,
	'number': {
		pattern: /(^|[^\w$@])(?:\d+(?:[/.]\d+)?(?:e[+-]?\d+)?|0x[a-f0-9]+|[1-9]\d?r[a-z0-9]+)[lmn]?(?![\w$@])/i,
		lookbehind: true
	},
	'function': {
		pattern: /((?:^|[^'])\()[\w*+!?'<>=/.-]+(?=[\s)]|$)/,
		lookbehind: true
	},
	'operator': /[#@^`~]/,
	'punctuation': /[{}\[\](),]/
};

Prism.languages.cmake = {
	'comment': /#.*/,
	'string': {
		pattern: /"(?:[^\\"]|\\.)*"/,
		greedy: true,
		inside: {
			'interpolation': {
				pattern: /\$\{(?:[^{}$]|\$\{[^{}$]*\})*\}/,
				inside: {
					'punctuation': /\$\{|\}/,
					'variable': /\w+/
				}
			}
		}
	},
	'variable': /\b(?:CMAKE_\w+|\w+_(?:(?:BINARY|SOURCE)_DIR|DESCRIPTION|HOMEPAGE_URL|ROOT|VERSION(?:_MAJOR|_MINOR|_PATCH|_TWEAK)?)|(?:ANDROID|APPLE|BORLAND|BUILD_SHARED_LIBS|CACHE|CPACK_(?:ABSOLUTE_DESTINATION_FILES|COMPONENT_INCLUDE_TOPLEVEL_DIRECTORY|ERROR_ON_ABSOLUTE_INSTALL_DESTINATION|INCLUDE_TOPLEVEL_DIRECTORY|INSTALL_DEFAULT_DIRECTORY_PERMISSIONS|INSTALL_SCRIPT|PACKAGING_INSTALL_PREFIX|SET_DESTDIR|WARN_ON_ABSOLUTE_INSTALL_DESTINATION)|CTEST_(?:BINARY_DIRECTORY|BUILD_COMMAND|BUILD_NAME|BZR_COMMAND|BZR_UPDATE_OPTIONS|CHANGE_ID|CHECKOUT_COMMAND|CONFIGURATION_TYPE|CONFIGURE_COMMAND|COVERAGE_COMMAND|COVERAGE_EXTRA_FLAGS|CURL_OPTIONS|CUSTOM_(?:COVERAGE_EXCLUDE|ERROR_EXCEPTION|ERROR_MATCH|ERROR_POST_CONTEXT|ERROR_PRE_CONTEXT|MAXIMUM_FAILED_TEST_OUTPUT_SIZE|MAXIMUM_NUMBER_OF_(?:ERRORS|WARNINGS)|MAXIMUM_PASSED_TEST_OUTPUT_SIZE|MEMCHECK_IGNORE|POST_MEMCHECK|POST_TEST|PRE_MEMCHECK|PRE_TEST|TESTS_IGNORE|WARNING_EXCEPTION|WARNING_MATCH)|CVS_CHECKOUT|CVS_COMMAND|CVS_UPDATE_OPTIONS|DROP_LOCATION|DROP_METHOD|DROP_SITE|DROP_SITE_CDASH|DROP_SITE_PASSWORD|DROP_SITE_USER|EXTRA_COVERAGE_GLOB|GIT_COMMAND|GIT_INIT_SUBMODULES|GIT_UPDATE_CUSTOM|GIT_UPDATE_OPTIONS|HG_COMMAND|HG_UPDATE_OPTIONS|LABELS_FOR_SUBPROJECTS|MEMORYCHECK_(?:COMMAND|COMMAND_OPTIONS|SANITIZER_OPTIONS|SUPPRESSIONS_FILE|TYPE)|NIGHTLY_START_TIME|P4_CLIENT|P4_COMMAND|P4_OPTIONS|P4_UPDATE_OPTIONS|RUN_CURRENT_SCRIPT|SCP_COMMAND|SITE|SOURCE_DIRECTORY|SUBMIT_URL|SVN_COMMAND|SVN_OPTIONS|SVN_UPDATE_OPTIONS|TEST_LOAD|TEST_TIMEOUT|TRIGGER_SITE|UPDATE_COMMAND|UPDATE_OPTIONS|UPDATE_VERSION_ONLY|USE_LAUNCHERS)|CYGWIN|ENV|EXECUTABLE_OUTPUT_PATH|GHS-MULTI|IOS|LIBRARY_OUTPUT_PATH|MINGW|MSVC(?:10|11|12|14|60|70|71|80|90|_IDE|_TOOLSET_VERSION|_VERSION)?|MSYS|PROJECT_NAME|UNIX|WIN32|WINCE|WINDOWS_PHONE|WINDOWS_STORE|XCODE))\b/,
	'property': /\b(?:cxx_\w+|(?:ARCHIVE_OUTPUT_(?:DIRECTORY|NAME)|COMPILE_DEFINITIONS|COMPILE_PDB_NAME|COMPILE_PDB_OUTPUT_DIRECTORY|EXCLUDE_FROM_DEFAULT_BUILD|IMPORTED_(?:IMPLIB|LIBNAME|LINK_DEPENDENT_LIBRARIES|LINK_INTERFACE_LANGUAGES|LINK_INTERFACE_LIBRARIES|LINK_INTERFACE_MULTIPLICITY|LOCATION|NO_SONAME|OBJECTS|SONAME)|INTERPROCEDURAL_OPTIMIZATION|LIBRARY_OUTPUT_DIRECTORY|LIBRARY_OUTPUT_NAME|LINK_FLAGS|LINK_INTERFACE_LIBRARIES|LINK_INTERFACE_MULTIPLICITY|LOCATION|MAP_IMPORTED_CONFIG|OSX_ARCHITECTURES|OUTPUT_NAME|PDB_NAME|PDB_OUTPUT_DIRECTORY|RUNTIME_OUTPUT_DIRECTORY|RUNTIME_OUTPUT_NAME|STATIC_LIBRARY_FLAGS|VS_CSHARP|VS_DOTNET_REFERENCEPROP|VS_DOTNET_REFERENCE|VS_GLOBAL_SECTION_POST|VS_GLOBAL_SECTION_PRE|VS_GLOBAL|XCODE_ATTRIBUTE)_\w+|\w+_(?:CLANG_TIDY|COMPILER_LAUNCHER|CPPCHECK|CPPLINT|INCLUDE_WHAT_YOU_USE|OUTPUT_NAME|POSTFIX|VISIBILITY_PRESET)|ABSTRACT|ADDITIONAL_MAKE_CLEAN_FILES|ADVANCED|ALIASED_TARGET|ALLOW_DUPLICATE_CUSTOM_TARGETS|ANDROID_(?:ANT_ADDITIONAL_OPTIONS|API|API_MIN|ARCH|ASSETS_DIRECTORIES|GUI|JAR_DEPENDENCIES|NATIVE_LIB_DEPENDENCIES|NATIVE_LIB_DIRECTORIES|PROCESS_MAX|PROGUARD|PROGUARD_CONFIG_PATH|SECURE_PROPS_PATH|SKIP_ANT_STEP|STL_TYPE)|ARCHIVE_OUTPUT_DIRECTORY|ATTACHED_FILES|ATTACHED_FILES_ON_FAIL|AUTOGEN_(?:BUILD_DIR|ORIGIN_DEPENDS|PARALLEL|SOURCE_GROUP|TARGETS_FOLDER|TARGET_DEPENDS)|AUTOMOC|AUTOMOC_(?:COMPILER_PREDEFINES|DEPEND_FILTERS|EXECUTABLE|MACRO_NAMES|MOC_OPTIONS|SOURCE_GROUP|TARGETS_FOLDER)|AUTORCC|AUTORCC_EXECUTABLE|AUTORCC_OPTIONS|AUTORCC_SOURCE_GROUP|AUTOUIC|AUTOUIC_EXECUTABLE|AUTOUIC_OPTIONS|AUTOUIC_SEARCH_PATHS|BINARY_DIR|BUILDSYSTEM_TARGETS|BUILD_RPATH|BUILD_RPATH_USE_ORIGIN|BUILD_WITH_INSTALL_NAME_DIR|BUILD_WITH_INSTALL_RPATH|BUNDLE|BUNDLE_EXTENSION|CACHE_VARIABLES|CLEAN_NO_CUSTOM|COMMON_LANGUAGE_RUNTIME|COMPATIBLE_INTERFACE_(?:BOOL|NUMBER_MAX|NUMBER_MIN|STRING)|COMPILE_(?:DEFINITIONS|FEATURES|FLAGS|OPTIONS|PDB_NAME|PDB_OUTPUT_DIRECTORY)|COST|CPACK_DESKTOP_SHORTCUTS|CPACK_NEVER_OVERWRITE|CPACK_PERMANENT|CPACK_STARTUP_SHORTCUTS|CPACK_START_MENU_SHORTCUTS|CPACK_WIX_ACL|CROSSCOMPILING_EMULATOR|CUDA_EXTENSIONS|CUDA_PTX_COMPILATION|CUDA_RESOLVE_DEVICE_SYMBOLS|CUDA_SEPARABLE_COMPILATION|CUDA_STANDARD|CUDA_STANDARD_REQUIRED|CXX_EXTENSIONS|CXX_STANDARD|CXX_STANDARD_REQUIRED|C_EXTENSIONS|C_STANDARD|C_STANDARD_REQUIRED|DEBUG_CONFIGURATIONS|DEFINE_SYMBOL|DEFINITIONS|DEPENDS|DEPLOYMENT_ADDITIONAL_FILES|DEPLOYMENT_REMOTE_DIRECTORY|DISABLED|DISABLED_FEATURES|ECLIPSE_EXTRA_CPROJECT_CONTENTS|ECLIPSE_EXTRA_NATURES|ENABLED_FEATURES|ENABLED_LANGUAGES|ENABLE_EXPORTS|ENVIRONMENT|EXCLUDE_FROM_ALL|EXCLUDE_FROM_DEFAULT_BUILD|EXPORT_NAME|EXPORT_PROPERTIES|EXTERNAL_OBJECT|EchoString|FAIL_REGULAR_EXPRESSION|FIND_LIBRARY_USE_LIB32_PATHS|FIND_LIBRARY_USE_LIB64_PATHS|FIND_LIBRARY_USE_LIBX32_PATHS|FIND_LIBRARY_USE_OPENBSD_VERSIONING|FIXTURES_CLEANUP|FIXTURES_REQUIRED|FIXTURES_SETUP|FOLDER|FRAMEWORK|Fortran_FORMAT|Fortran_MODULE_DIRECTORY|GENERATED|GENERATOR_FILE_NAME|GENERATOR_IS_MULTI_CONFIG|GHS_INTEGRITY_APP|GHS_NO_SOURCE_GROUP_FILE|GLOBAL_DEPENDS_DEBUG_MODE|GLOBAL_DEPENDS_NO_CYCLES|GNUtoMS|HAS_CXX|HEADER_FILE_ONLY|HELPSTRING|IMPLICIT_DEPENDS_INCLUDE_TRANSFORM|IMPORTED|IMPORTED_(?:COMMON_LANGUAGE_RUNTIME|CONFIGURATIONS|GLOBAL|IMPLIB|LIBNAME|LINK_DEPENDENT_LIBRARIES|LINK_INTERFACE_(?:LANGUAGES|LIBRARIES|MULTIPLICITY)|LOCATION|NO_SONAME|OBJECTS|SONAME)|IMPORT_PREFIX|IMPORT_SUFFIX|INCLUDE_DIRECTORIES|INCLUDE_REGULAR_EXPRESSION|INSTALL_NAME_DIR|INSTALL_RPATH|INSTALL_RPATH_USE_LINK_PATH|INTERFACE_(?:AUTOUIC_OPTIONS|COMPILE_DEFINITIONS|COMPILE_FEATURES|COMPILE_OPTIONS|INCLUDE_DIRECTORIES|LINK_DEPENDS|LINK_DIRECTORIES|LINK_LIBRARIES|LINK_OPTIONS|POSITION_INDEPENDENT_CODE|SOURCES|SYSTEM_INCLUDE_DIRECTORIES)|INTERPROCEDURAL_OPTIMIZATION|IN_TRY_COMPILE|IOS_INSTALL_COMBINED|JOB_POOLS|JOB_POOL_COMPILE|JOB_POOL_LINK|KEEP_EXTENSION|LABELS|LANGUAGE|LIBRARY_OUTPUT_DIRECTORY|LINKER_LANGUAGE|LINK_(?:DEPENDS|DEPENDS_NO_SHARED|DIRECTORIES|FLAGS|INTERFACE_LIBRARIES|INTERFACE_MULTIPLICITY|LIBRARIES|OPTIONS|SEARCH_END_STATIC|SEARCH_START_STATIC|WHAT_YOU_USE)|LISTFILE_STACK|LOCATION|MACOSX_BUNDLE|MACOSX_BUNDLE_INFO_PLIST|MACOSX_FRAMEWORK_INFO_PLIST|MACOSX_PACKAGE_LOCATION|MACOSX_RPATH|MACROS|MANUALLY_ADDED_DEPENDENCIES|MEASUREMENT|MODIFIED|NAME|NO_SONAME|NO_SYSTEM_FROM_IMPORTED|OBJECT_DEPENDS|OBJECT_OUTPUTS|OSX_ARCHITECTURES|OUTPUT_NAME|PACKAGES_FOUND|PACKAGES_NOT_FOUND|PARENT_DIRECTORY|PASS_REGULAR_EXPRESSION|PDB_NAME|PDB_OUTPUT_DIRECTORY|POSITION_INDEPENDENT_CODE|POST_INSTALL_SCRIPT|PREDEFINED_TARGETS_FOLDER|PREFIX|PRE_INSTALL_SCRIPT|PRIVATE_HEADER|PROCESSORS|PROCESSOR_AFFINITY|PROJECT_LABEL|PUBLIC_HEADER|REPORT_UNDEFINED_PROPERTIES|REQUIRED_FILES|RESOURCE|RESOURCE_LOCK|RULE_LAUNCH_COMPILE|RULE_LAUNCH_CUSTOM|RULE_LAUNCH_LINK|RULE_MESSAGES|RUNTIME_OUTPUT_DIRECTORY|RUN_SERIAL|SKIP_AUTOGEN|SKIP_AUTOMOC|SKIP_AUTORCC|SKIP_AUTOUIC|SKIP_BUILD_RPATH|SKIP_RETURN_CODE|SOURCES|SOURCE_DIR|SOVERSION|STATIC_LIBRARY_FLAGS|STATIC_LIBRARY_OPTIONS|STRINGS|SUBDIRECTORIES|SUFFIX|SYMBOLIC|TARGET_ARCHIVES_MAY_BE_SHARED_LIBS|TARGET_MESSAGES|TARGET_SUPPORTS_SHARED_LIBS|TESTS|TEST_INCLUDE_FILE|TEST_INCLUDE_FILES|TIMEOUT|TIMEOUT_AFTER_MATCH|TYPE|USE_FOLDERS|VALUE|VARIABLES|VERSION|VISIBILITY_INLINES_HIDDEN|VS_(?:CONFIGURATION_TYPE|COPY_TO_OUT_DIR|DEBUGGER_(?:COMMAND|COMMAND_ARGUMENTS|ENVIRONMENT|WORKING_DIRECTORY)|DEPLOYMENT_CONTENT|DEPLOYMENT_LOCATION|DOTNET_REFERENCES|DOTNET_REFERENCES_COPY_LOCAL|INCLUDE_IN_VSIX|IOT_STARTUP_TASK|KEYWORD|RESOURCE_GENERATOR|SCC_AUXPATH|SCC_LOCALPATH|SCC_PROJECTNAME|SCC_PROVIDER|SDK_REFERENCES|SHADER_(?:DISABLE_OPTIMIZATIONS|ENABLE_DEBUG|ENTRYPOINT|FLAGS|MODEL|OBJECT_FILE_NAME|OUTPUT_HEADER_FILE|TYPE|VARIABLE_NAME)|STARTUP_PROJECT|TOOL_OVERRIDE|USER_PROPS|WINRT_COMPONENT|WINRT_EXTENSIONS|WINRT_REFERENCES|XAML_TYPE)|WILL_FAIL|WIN32_EXECUTABLE|WINDOWS_EXPORT_ALL_SYMBOLS|WORKING_DIRECTORY|WRAP_EXCLUDE|XCODE_(?:EMIT_EFFECTIVE_PLATFORM_NAME|EXPLICIT_FILE_TYPE|FILE_ATTRIBUTES|LAST_KNOWN_FILE_TYPE|PRODUCT_TYPE|SCHEME_(?:ADDRESS_SANITIZER|ADDRESS_SANITIZER_USE_AFTER_RETURN|ARGUMENTS|DISABLE_MAIN_THREAD_CHECKER|DYNAMIC_LIBRARY_LOADS|DYNAMIC_LINKER_API_USAGE|ENVIRONMENT|EXECUTABLE|GUARD_MALLOC|MAIN_THREAD_CHECKER_STOP|MALLOC_GUARD_EDGES|MALLOC_SCRIBBLE|MALLOC_STACK|THREAD_SANITIZER(?:_STOP)?|UNDEFINED_BEHAVIOUR_SANITIZER(?:_STOP)?|ZOMBIE_OBJECTS))|XCTEST)\b/,
	'keyword': /\b(?:add_compile_definitions|add_compile_options|add_custom_command|add_custom_target|add_definitions|add_dependencies|add_executable|add_library|add_link_options|add_subdirectory|add_test|aux_source_directory|break|build_command|build_name|cmake_host_system_information|cmake_minimum_required|cmake_parse_arguments|cmake_policy|configure_file|continue|create_test_sourcelist|ctest_build|ctest_configure|ctest_coverage|ctest_empty_binary_directory|ctest_memcheck|ctest_read_custom_files|ctest_run_script|ctest_sleep|ctest_start|ctest_submit|ctest_test|ctest_update|ctest_upload|define_property|else|elseif|enable_language|enable_testing|endforeach|endfunction|endif|endmacro|endwhile|exec_program|execute_process|export|export_library_dependencies|file|find_file|find_library|find_package|find_path|find_program|fltk_wrap_ui|foreach|function|get_cmake_property|get_directory_property|get_filename_component|get_property|get_source_file_property|get_target_property|get_test_property|if|include|include_directories|include_external_msproject|include_guard|include_regular_expression|install|install_files|install_programs|install_targets|link_directories|link_libraries|list|load_cache|load_command|macro|make_directory|mark_as_advanced|math|message|option|output_required_files|project|qt_wrap_cpp|qt_wrap_ui|remove|remove_definitions|return|separate_arguments|set|set_directory_properties|set_property|set_source_files_properties|set_target_properties|set_tests_properties|site_name|source_group|string|subdir_depends|subdirs|target_compile_definitions|target_compile_features|target_compile_options|target_include_directories|target_link_directories|target_link_libraries|target_link_options|target_sources|try_compile|try_run|unset|use_mangled_mesa|utility_source|variable_requires|variable_watch|while|write_file)(?=\s*\()\b/,
	'boolean': /\b(?:FALSE|OFF|ON|TRUE)\b/,
	'namespace': /\b(?:INTERFACE|PRIVATE|PROPERTIES|PUBLIC|SHARED|STATIC|TARGET_OBJECTS)\b/,
	'operator': /\b(?:AND|DEFINED|EQUAL|GREATER|LESS|MATCHES|NOT|OR|STREQUAL|STRGREATER|STRLESS|VERSION_EQUAL|VERSION_GREATER|VERSION_LESS)\b/,
	'inserted': {
		pattern: /\b\w+::\w+\b/,
		alias: 'class-name'
	},
	'number': /\b\d+(?:\.\d+)*\b/,
	'function': /\b[a-z_]\w*(?=\s*\()\b/i,
	'punctuation': /[()>}]|\$[<{]/
};

Prism.languages.cobol = {
	'comment': {
		pattern: /\*>.*|(^[ \t]*)\*.*/m,
		lookbehind: true,
		greedy: true
	},
	'string': {
		pattern: /[xzgn]?(?:"(?:[^\r\n"]|"")*"(?!")|'(?:[^\r\n']|'')*'(?!'))/i,
		greedy: true
	},

	'level': {
		pattern: /(^[ \t]*)\d+\b/m,
		lookbehind: true,
		greedy: true,
		alias: 'number'
	},

	'class-name': {
		// https://github.com/antlr/grammars-v4/blob/42edd5b687d183b5fa679e858a82297bd27141e7/cobol85/Cobol85.g4#L1015
		pattern: /(\bpic(?:ture)?\s+)(?:(?:[-\w$/,:*+<>]|\.(?!\s|$))(?:\(\d+\))?)+/i,
		lookbehind: true,
		inside: {
			'number': {
				pattern: /(\()\d+/,
				lookbehind: true
			},
			'punctuation': /[()]/
		}
	},

	'keyword': {
		pattern: /(^|[^\w-])(?:ABORT|ACCEPT|ACCESS|ADD|ADDRESS|ADVANCING|AFTER|ALIGNED|ALL|ALPHABET|ALPHABETIC|ALPHABETIC-LOWER|ALPHABETIC-UPPER|ALPHANUMERIC|ALPHANUMERIC-EDITED|ALSO|ALTER|ALTERNATE|ANY|ARE|AREA|AREAS|AS|ASCENDING|ASCII|ASSIGN|ASSOCIATED-DATA|ASSOCIATED-DATA-LENGTH|AT|ATTRIBUTE|AUTHOR|AUTO|AUTO-SKIP|BACKGROUND-COLOR|BACKGROUND-COLOUR|BASIS|BEEP|BEFORE|BEGINNING|BELL|BINARY|BIT|BLANK|BLINK|BLOCK|BOTTOM|BOUNDS|BY|BYFUNCTION|BYTITLE|CALL|CANCEL|CAPABLE|CCSVERSION|CD|CF|CH|CHAINING|CHANGED|CHANNEL|CHARACTER|CHARACTERS|CLASS|CLASS-ID|CLOCK-UNITS|CLOSE|CLOSE-DISPOSITION|COBOL|CODE|CODE-SET|COL|COLLATING|COLUMN|COM-REG|COMMA|COMMITMENT|COMMON|COMMUNICATION|COMP|COMP-1|COMP-2|COMP-3|COMP-4|COMP-5|COMPUTATIONAL|COMPUTATIONAL-1|COMPUTATIONAL-2|COMPUTATIONAL-3|COMPUTATIONAL-4|COMPUTATIONAL-5|COMPUTE|CONFIGURATION|CONTAINS|CONTENT|CONTINUE|CONTROL|CONTROL-POINT|CONTROLS|CONVENTION|CONVERTING|COPY|CORR|CORRESPONDING|COUNT|CRUNCH|CURRENCY|CURSOR|DATA|DATA-BASE|DATE|DATE-COMPILED|DATE-WRITTEN|DAY|DAY-OF-WEEK|DBCS|DE|DEBUG-CONTENTS|DEBUG-ITEM|DEBUG-LINE|DEBUG-NAME|DEBUG-SUB-1|DEBUG-SUB-2|DEBUG-SUB-3|DEBUGGING|DECIMAL-POINT|DECLARATIVES|DEFAULT|DEFAULT-DISPLAY|DEFINITION|DELETE|DELIMITED|DELIMITER|DEPENDING|DESCENDING|DESTINATION|DETAIL|DFHRESP|DFHVALUE|DISABLE|DISK|DISPLAY|DISPLAY-1|DIVIDE|DIVISION|DONTCARE|DOUBLE|DOWN|DUPLICATES|DYNAMIC|EBCDIC|EGCS|EGI|ELSE|EMI|EMPTY-CHECK|ENABLE|END|END-ACCEPT|END-ADD|END-CALL|END-COMPUTE|END-DELETE|END-DIVIDE|END-EVALUATE|END-IF|END-MULTIPLY|END-OF-PAGE|END-PERFORM|END-READ|END-RECEIVE|END-RETURN|END-REWRITE|END-SEARCH|END-START|END-STRING|END-SUBTRACT|END-UNSTRING|END-WRITE|ENDING|ENTER|ENTRY|ENTRY-PROCEDURE|ENVIRONMENT|EOL|EOP|EOS|ERASE|ERROR|ESCAPE|ESI|EVALUATE|EVENT|EVERY|EXCEPTION|EXCLUSIVE|EXHIBIT|EXIT|EXPORT|EXTEND|EXTENDED|EXTERNAL|FD|FILE|FILE-CONTROL|FILLER|FINAL|FIRST|FOOTING|FOR|FOREGROUND-COLOR|FOREGROUND-COLOUR|FROM|FULL|FUNCTION|FUNCTION-POINTER|FUNCTIONNAME|GENERATE|GIVING|GLOBAL|GO|GOBACK|GRID|GROUP|HEADING|HIGH-VALUE|HIGH-VALUES|HIGHLIGHT|I-O|I-O-CONTROL|ID|IDENTIFICATION|IF|IMPLICIT|IMPORT|IN|INDEX|INDEXED|INDICATE|INITIAL|INITIALIZE|INITIATE|INPUT|INPUT-OUTPUT|INSPECT|INSTALLATION|INTEGER|INTO|INVALID|INVOKE|IS|JUST|JUSTIFIED|KANJI|KEPT|KEY|KEYBOARD|LABEL|LANGUAGE|LAST|LB|LD|LEADING|LEFT|LEFTLINE|LENGTH|LENGTH-CHECK|LIBACCESS|LIBPARAMETER|LIBRARY|LIMIT|LIMITS|LINAGE|LINAGE-COUNTER|LINE|LINE-COUNTER|LINES|LINKAGE|LIST|LOCAL|LOCAL-STORAGE|LOCK|LONG-DATE|LONG-TIME|LOW-VALUE|LOW-VALUES|LOWER|LOWLIGHT|MEMORY|MERGE|MESSAGE|MMDDYYYY|MODE|MODULES|MORE-LABELS|MOVE|MULTIPLE|MULTIPLY|NAMED|NATIONAL|NATIONAL-EDITED|NATIVE|NEGATIVE|NETWORK|NEXT|NO|NO-ECHO|NULL|NULLS|NUMBER|NUMERIC|NUMERIC-DATE|NUMERIC-EDITED|NUMERIC-TIME|OBJECT-COMPUTER|OCCURS|ODT|OF|OFF|OMITTED|ON|OPEN|OPTIONAL|ORDER|ORDERLY|ORGANIZATION|OTHER|OUTPUT|OVERFLOW|OVERLINE|OWN|PACKED-DECIMAL|PADDING|PAGE|PAGE-COUNTER|PASSWORD|PERFORM|PF|PH|PIC|PICTURE|PLUS|POINTER|PORT|POSITION|POSITIVE|PRINTER|PRINTING|PRIVATE|PROCEDURE|PROCEDURE-POINTER|PROCEDURES|PROCEED|PROCESS|PROGRAM|PROGRAM-ID|PROGRAM-LIBRARY|PROMPT|PURGE|QUEUE|QUOTE|QUOTES|RANDOM|RD|READ|READER|REAL|RECEIVE|RECEIVED|RECORD|RECORDING|RECORDS|RECURSIVE|REDEFINES|REEL|REF|REFERENCE|REFERENCES|RELATIVE|RELEASE|REMAINDER|REMARKS|REMOTE|REMOVAL|REMOVE|RENAMES|REPLACE|REPLACING|REPORT|REPORTING|REPORTS|REQUIRED|RERUN|RESERVE|RESET|RETURN|RETURN-CODE|RETURNING|REVERSE-VIDEO|REVERSED|REWIND|REWRITE|RF|RH|RIGHT|ROUNDED|RUN|SAME|SAVE|SCREEN|SD|SEARCH|SECTION|SECURE|SECURITY|SEGMENT|SEGMENT-LIMIT|SELECT|SEND|SENTENCE|SEPARATE|SEQUENCE|SEQUENTIAL|SET|SHARED|SHAREDBYALL|SHAREDBYRUNUNIT|SHARING|SHIFT-IN|SHIFT-OUT|SHORT-DATE|SIGN|SIZE|SORT|SORT-CONTROL|SORT-CORE-SIZE|SORT-FILE-SIZE|SORT-MERGE|SORT-MESSAGE|SORT-MODE-SIZE|SORT-RETURN|SOURCE|SOURCE-COMPUTER|SPACE|SPACES|SPECIAL-NAMES|STANDARD|STANDARD-1|STANDARD-2|START|STATUS|STOP|STRING|SUB-QUEUE-1|SUB-QUEUE-2|SUB-QUEUE-3|SUBTRACT|SUM|SUPPRESS|SYMBOL|SYMBOLIC|SYNC|SYNCHRONIZED|TABLE|TALLY|TALLYING|TAPE|TASK|TERMINAL|TERMINATE|TEST|TEXT|THEN|THREAD|THREAD-LOCAL|THROUGH|THRU|TIME|TIMER|TIMES|TITLE|TO|TODAYS-DATE|TODAYS-NAME|TOP|TRAILING|TRUNCATED|TYPE|TYPEDEF|UNDERLINE|UNIT|UNSTRING|UNTIL|UP|UPON|USAGE|USE|USING|VALUE|VALUES|VARYING|VIRTUAL|WAIT|WHEN|WHEN-COMPILED|WITH|WORDS|WORKING-STORAGE|WRITE|YEAR|YYYYDDD|YYYYMMDD|ZERO-FILL|ZEROES|ZEROS)(?![\w-])/i,
		lookbehind: true
	},

	'boolean': {
		pattern: /(^|[^\w-])(?:false|true)(?![\w-])/i,
		lookbehind: true
	},
	'number': {
		pattern: /(^|[^\w-])(?:[+-]?(?:(?:\d+(?:[.,]\d+)?|[.,]\d+)(?:e[+-]?\d+)?|zero))(?![\w-])/i,
		lookbehind: true
	},
	'operator': [
		/<>|[<>]=?|[=+*/&]/,
		{
			pattern: /(^|[^\w-])(?:-|and|equal|greater|less|not|or|than)(?![\w-])/i,
			lookbehind: true
		}
	],
	'punctuation': /[.:,()]/
};

(function (Prism) {

	// Ignore comments starting with { to privilege string interpolation highlighting
	var comment = /#(?!\{).+/;
	var interpolation = {
		pattern: /#\{[^}]+\}/,
		alias: 'variable'
	};

	Prism.languages.coffeescript = Prism.languages.extend('javascript', {
		'comment': comment,
		'string': [

			// Strings are multiline
			{
				pattern: /'(?:\\[\s\S]|[^\\'])*'/,
				greedy: true
			},

			{
				// Strings are multiline
				pattern: /"(?:\\[\s\S]|[^\\"])*"/,
				greedy: true,
				inside: {
					'interpolation': interpolation
				}
			}
		],
		'keyword': /\b(?:and|break|by|catch|class|continue|debugger|delete|do|each|else|extend|extends|false|finally|for|if|in|instanceof|is|isnt|let|loop|namespace|new|no|not|null|of|off|on|or|own|return|super|switch|then|this|throw|true|try|typeof|undefined|unless|until|when|while|window|with|yes|yield)\b/,
		'class-member': {
			pattern: /@(?!\d)\w+/,
			alias: 'variable'
		}
	});

	Prism.languages.insertBefore('coffeescript', 'comment', {
		'multiline-comment': {
			pattern: /###[\s\S]+?###/,
			alias: 'comment'
		},

		// Block regexp can contain comments and interpolation
		'block-regex': {
			pattern: /\/{3}[\s\S]*?\/{3}/,
			alias: 'regex',
			inside: {
				'comment': comment,
				'interpolation': interpolation
			}
		}
	});

	Prism.languages.insertBefore('coffeescript', 'string', {
		'inline-javascript': {
			pattern: /`(?:\\[\s\S]|[^\\`])*`/,
			inside: {
				'delimiter': {
					pattern: /^`|`$/,
					alias: 'punctuation'
				},
				'script': {
					pattern: /[\s\S]+/,
					alias: 'language-javascript',
					inside: Prism.languages.javascript
				}
			}
		},

		// Block strings
		'multiline-string': [
			{
				pattern: /'''[\s\S]*?'''/,
				greedy: true,
				alias: 'string'
			},
			{
				pattern: /"""[\s\S]*?"""/,
				greedy: true,
				alias: 'string',
				inside: {
					interpolation: interpolation
				}
			}
		]

	});

	Prism.languages.insertBefore('coffeescript', 'keyword', {
		// Object property
		'property': /(?!\d)\w+(?=\s*:(?!:))/
	});

	delete Prism.languages.coffeescript['template-string'];

	Prism.languages.coffee = Prism.languages.coffeescript;
}(Prism));

(function (Prism) {

	var string = /("|')(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1/;
	var selectorInside;

	Prism.languages.css.selector = {
		pattern: Prism.languages.css.selector.pattern,
		lookbehind: true,
		inside: selectorInside = {
			'pseudo-element': /:(?:after|before|first-letter|first-line|selection)|::[-\w]+/,
			'pseudo-class': /:[-\w]+/,
			'class': /\.[-\w]+/,
			'id': /#[-\w]+/,
			'attribute': {
				pattern: RegExp('\\[(?:[^[\\]"\']|' + string.source + ')*\\]'),
				greedy: true,
				inside: {
					'punctuation': /^\[|\]$/,
					'case-sensitivity': {
						pattern: /(\s)[si]$/i,
						lookbehind: true,
						alias: 'keyword'
					},
					'namespace': {
						pattern: /^(\s*)(?:(?!\s)[-*\w\xA0-\uFFFF])*\|(?!=)/,
						lookbehind: true,
						inside: {
							'punctuation': /\|$/
						}
					},
					'attr-name': {
						pattern: /^(\s*)(?:(?!\s)[-\w\xA0-\uFFFF])+/,
						lookbehind: true
					},
					'attr-value': [
						string,
						{
							pattern: /(=\s*)(?:(?!\s)[-\w\xA0-\uFFFF])+(?=\s*$)/,
							lookbehind: true
						}
					],
					'operator': /[|~*^$]?=/
				}
			},
			'n-th': [
				{
					pattern: /(\(\s*)[+-]?\d*[\dn](?:\s*[+-]\s*\d+)?(?=\s*\))/,
					lookbehind: true,
					inside: {
						'number': /[\dn]+/,
						'operator': /[+-]/
					}
				},
				{
					pattern: /(\(\s*)(?:even|odd)(?=\s*\))/i,
					lookbehind: true
				}
			],
			'combinator': />|\+|~|\|\|/,

			// the `tag` token has been existed and removed.
			// because we can't find a perfect tokenize to match it.
			// if you want to add it, please read https://github.com/PrismJS/prism/pull/2373 first.

			'punctuation': /[(),]/,
		}
	};

	Prism.languages.css['atrule'].inside['selector-function-argument'].inside = selectorInside;

	Prism.languages.insertBefore('css', 'property', {
		'variable': {
			pattern: /(^|[^-\w\xA0-\uFFFF])--(?!\s)[-_a-z\xA0-\uFFFF](?:(?!\s)[-\w\xA0-\uFFFF])*/i,
			lookbehind: true
		}
	});

	var unit = {
		pattern: /(\b\d+)(?:%|[a-z]+(?![\w-]))/,
		lookbehind: true
	};
	// 123 -123 .123 -.123 12.3 -12.3
	var number = {
		pattern: /(^|[^\w.-])-?(?:\d+(?:\.\d+)?|\.\d+)/,
		lookbehind: true
	};

	Prism.languages.insertBefore('css', 'function', {
		'operator': {
			pattern: /(\s)[+\-*\/](?=\s)/,
			lookbehind: true
		},
		// CAREFUL!
		// Previewers and Inline color use hexcode and color.
		'hexcode': {
			pattern: /\B#[\da-f]{3,8}\b/i,
			alias: 'color'
		},
		'color': [
			{
				pattern: /(^|[^\w-])(?:AliceBlue|AntiqueWhite|Aqua|Aquamarine|Azure|Beige|Bisque|Black|BlanchedAlmond|Blue|BlueViolet|Brown|BurlyWood|CadetBlue|Chartreuse|Chocolate|Coral|CornflowerBlue|Cornsilk|Crimson|Cyan|DarkBlue|DarkCyan|DarkGoldenRod|DarkGr[ae]y|DarkGreen|DarkKhaki|DarkMagenta|DarkOliveGreen|DarkOrange|DarkOrchid|DarkRed|DarkSalmon|DarkSeaGreen|DarkSlateBlue|DarkSlateGr[ae]y|DarkTurquoise|DarkViolet|DeepPink|DeepSkyBlue|DimGr[ae]y|DodgerBlue|FireBrick|FloralWhite|ForestGreen|Fuchsia|Gainsboro|GhostWhite|Gold|GoldenRod|Gr[ae]y|Green|GreenYellow|HoneyDew|HotPink|IndianRed|Indigo|Ivory|Khaki|Lavender|LavenderBlush|LawnGreen|LemonChiffon|LightBlue|LightCoral|LightCyan|LightGoldenRodYellow|LightGr[ae]y|LightGreen|LightPink|LightSalmon|LightSeaGreen|LightSkyBlue|LightSlateGr[ae]y|LightSteelBlue|LightYellow|Lime|LimeGreen|Linen|Magenta|Maroon|MediumAquaMarine|MediumBlue|MediumOrchid|MediumPurple|MediumSeaGreen|MediumSlateBlue|MediumSpringGreen|MediumTurquoise|MediumVioletRed|MidnightBlue|MintCream|MistyRose|Moccasin|NavajoWhite|Navy|OldLace|Olive|OliveDrab|Orange|OrangeRed|Orchid|PaleGoldenRod|PaleGreen|PaleTurquoise|PaleVioletRed|PapayaWhip|PeachPuff|Peru|Pink|Plum|PowderBlue|Purple|RebeccaPurple|Red|RosyBrown|RoyalBlue|SaddleBrown|Salmon|SandyBrown|SeaGreen|SeaShell|Sienna|Silver|SkyBlue|SlateBlue|SlateGr[ae]y|Snow|SpringGreen|SteelBlue|Tan|Teal|Thistle|Tomato|Transparent|Turquoise|Violet|Wheat|White|WhiteSmoke|Yellow|YellowGreen)(?![\w-])/i,
				lookbehind: true
			},
			{
				pattern: /\b(?:hsl|rgb)\(\s*\d{1,3}\s*,\s*\d{1,3}%?\s*,\s*\d{1,3}%?\s*\)\B|\b(?:hsl|rgb)a\(\s*\d{1,3}\s*,\s*\d{1,3}%?\s*,\s*\d{1,3}%?\s*,\s*(?:0|0?\.\d+|1)\s*\)\B/i,
				inside: {
					'unit': unit,
					'number': number,
					'function': /[\w-]+(?=\()/,
					'punctuation': /[(),]/
				}
			}
		],
		// it's important that there is no boundary assertion after the hex digits
		'entity': /\\[\da-f]{1,8}/i,
		'unit': unit,
		'number': number
	});

}(Prism));

Prism.languages.d = Prism.languages.extend('clike', {
	'comment': [
		{
			// Shebang
			pattern: /^\s*#!.+/,
			greedy: true
		},
		{
			pattern: RegExp(/(^|[^\\])/.source + '(?:' + [
				// /+ comment +/
				// Allow one level of nesting
				/\/\+(?:\/\+(?:[^+]|\+(?!\/))*\+\/|(?!\/\+)[\s\S])*?\+\//.source,
				// // comment
				/\/\/.*/.source,
				// /* comment */
				/\/\*[\s\S]*?\*\//.source
			].join('|') + ')'),
			lookbehind: true,
			greedy: true
		}
	],
	'string': [
		{
			pattern: RegExp([
				// r"", x""
				/\b[rx]"(?:\\[\s\S]|[^\\"])*"[cwd]?/.source,

				// q"[]", q"()", q"<>", q"{}"
				/\bq"(?:\[[\s\S]*?\]|\([\s\S]*?\)|<[\s\S]*?>|\{[\s\S]*?\})"/.source,

				// q"IDENT
				// ...
				// IDENT"
				/\bq"((?!\d)\w+)$[\s\S]*?^\1"/.source,

				// q"//", q"||", etc.
				// eslint-disable-next-line regexp/strict
				/\bq"(.)[\s\S]*?\2"/.source,

				// eslint-disable-next-line regexp/strict
				/(["`])(?:\\[\s\S]|(?!\3)[^\\])*\3[cwd]?/.source
			].join('|'), 'm'),
			greedy: true
		},
		{
			pattern: /\bq\{(?:\{[^{}]*\}|[^{}])*\}/,
			greedy: true,
			alias: 'token-string'
		}
	],

	// In order: $, keywords and special tokens, globally defined symbols
	'keyword': /\$|\b(?:__(?:(?:DATE|EOF|FILE|FUNCTION|LINE|MODULE|PRETTY_FUNCTION|TIMESTAMP|TIME|VENDOR|VERSION)__|gshared|parameters|traits|vector)|abstract|alias|align|asm|assert|auto|body|bool|break|byte|case|cast|catch|cdouble|cent|cfloat|char|class|const|continue|creal|dchar|debug|default|delegate|delete|deprecated|do|double|dstring|else|enum|export|extern|false|final|finally|float|for|foreach|foreach_reverse|function|goto|idouble|if|ifloat|immutable|import|inout|int|interface|invariant|ireal|lazy|long|macro|mixin|module|new|nothrow|null|out|override|package|pragma|private|protected|ptrdiff_t|public|pure|real|ref|return|scope|shared|short|size_t|static|string|struct|super|switch|synchronized|template|this|throw|true|try|typedef|typeid|typeof|ubyte|ucent|uint|ulong|union|unittest|ushort|version|void|volatile|wchar|while|with|wstring)\b/,

	'number': [
		// The lookbehind and the negative look-ahead try to prevent bad highlighting of the .. operator
		// Hexadecimal numbers must be handled separately to avoid problems with exponent "e"
		/\b0x\.?[a-f\d_]+(?:(?!\.\.)\.[a-f\d_]*)?(?:p[+-]?[a-f\d_]+)?[ulfi]{0,4}/i,
		{
			pattern: /((?:\.\.)?)(?:\b0b\.?|\b|\.)\d[\d_]*(?:(?!\.\.)\.[\d_]*)?(?:e[+-]?\d[\d_]*)?[ulfi]{0,4}/i,
			lookbehind: true
		}
	],

	'operator': /\|[|=]?|&[&=]?|\+[+=]?|-[-=]?|\.?\.\.|=[>=]?|!(?:i[ns]\b|<>?=?|>=?|=)?|\bi[ns]\b|(?:<[<>]?|>>?>?|\^\^|[*\/%^~])=?/
});

Prism.languages.insertBefore('d', 'string', {
	// Characters
	// 'a', '\\', '\n', '\xFF', '\377', '\uFFFF', '\U0010FFFF', '\quot'
	'char': /'(?:\\(?:\W|\w+)|[^\\])'/
});

Prism.languages.insertBefore('d', 'keyword', {
	'property': /\B@\w*/
});

Prism.languages.insertBefore('d', 'function', {
	'register': {
		// Iasm registers
		pattern: /\b(?:[ABCD][LHX]|E?(?:BP|DI|SI|SP)|[BS]PL|[ECSDGF]S|CR[0234]|[DS]IL|DR[012367]|E[ABCD]X|X?MM[0-7]|R(?:1[0-5]|[89])[BWD]?|R[ABCD]X|R[BS]P|R[DS]I|TR[3-7]|XMM(?:1[0-5]|[89])|YMM(?:1[0-5]|\d))\b|\bST(?:\([0-7]\)|\b)/,
		alias: 'variable'
	}
});

(function (Prism) {
	var keywords = [
		/\b(?:async|sync|yield)\*/,
		/\b(?:abstract|assert|async|await|break|case|catch|class|const|continue|covariant|default|deferred|do|dynamic|else|enum|export|extends|extension|external|factory|final|finally|for|get|hide|if|implements|import|in|interface|library|mixin|new|null|on|operator|part|rethrow|return|set|show|static|super|switch|sync|this|throw|try|typedef|var|void|while|with|yield)\b/
	];

	// Handles named imports, such as http.Client
	var packagePrefix = /(^|[^\w.])(?:[a-z]\w*\s*\.\s*)*(?:[A-Z]\w*\s*\.\s*)*/.source;

	// based on the dart naming conventions
	var className = {
		pattern: RegExp(packagePrefix + /[A-Z](?:[\d_A-Z]*[a-z]\w*)?\b/.source),
		lookbehind: true,
		inside: {
			'namespace': {
				pattern: /^[a-z]\w*(?:\s*\.\s*[a-z]\w*)*(?:\s*\.)?/,
				inside: {
					'punctuation': /\./
				}
			},
		}
	};

	Prism.languages.dart = Prism.languages.extend('clike', {
		'class-name': [
			className,
			{
				// variables and parameters
				// this to support class names (or generic parameters) which do not contain a lower case letter (also works for methods)
				pattern: RegExp(packagePrefix + /[A-Z]\w*(?=\s+\w+\s*[;,=()])/.source),
				lookbehind: true,
				inside: className.inside
			}
		],
		'keyword': keywords,
		'operator': /\bis!|\b(?:as|is)\b|\+\+|--|&&|\|\||<<=?|>>=?|~(?:\/=?)?|[+\-*\/%&^|=!<>]=?|\?/
	});

	Prism.languages.insertBefore('dart', 'string', {
		'string-literal': {
			pattern: /r?(?:("""|''')[\s\S]*?\1|(["'])(?:\\.|(?!\2)[^\\\r\n])*\2(?!\2))/,
			greedy: true,
			inside: {
				'interpolation': {
					pattern: /((?:^|[^\\])(?:\\{2})*)\$(?:\w+|\{(?:[^{}]|\{[^{}]*\})*\})/,
					lookbehind: true,
					inside: {
						'punctuation': /^\$\{?|\}$/,
						'expression': {
							pattern: /[\s\S]+/,
							inside: Prism.languages.dart
						}
					}
				},
				'string': /[\s\S]+/
			}
		},
		'string': undefined
	});

	Prism.languages.insertBefore('dart', 'class-name', {
		'metadata': {
			pattern: /@\w+/,
			alias: 'function'
		}
	});

	Prism.languages.insertBefore('dart', 'class-name', {
		'generics': {
			pattern: /<(?:[\w\s,.&?]|<(?:[\w\s,.&?]|<(?:[\w\s,.&?]|<[\w\s,.&?]*>)*>)*>)*>/,
			inside: {
				'class-name': className,
				'keyword': keywords,
				'punctuation': /[<>(),.:]/,
				'operator': /[?&|]/
			}
		},
	});
}(Prism));

(function (Prism) {

	Prism.languages.diff = {
		'coord': [
			// Match all kinds of coord lines (prefixed by "+++", "---" or "***").
			/^(?:\*{3}|-{3}|\+{3}).*$/m,
			// Match "@@ ... @@" coord lines in unified diff.
			/^@@.*@@$/m,
			// Match coord lines in normal diff (starts with a number).
			/^\d.*$/m
		]

		// deleted, inserted, unchanged, diff
	};

	/**
	 * A map from the name of a block to its line prefix.
	 *
	 * @type {Object<string, string>}
	 */
	var PREFIXES = {
		'deleted-sign': '-',
		'deleted-arrow': '<',
		'inserted-sign': '+',
		'inserted-arrow': '>',
		'unchanged': ' ',
		'diff': '!',
	};

	// add a token for each prefix
	Object.keys(PREFIXES).forEach(function (name) {
		var prefix = PREFIXES[name];

		var alias = [];
		if (!/^\w+$/.test(name)) { // "deleted-sign" -> "deleted"
			alias.push(/\w+/.exec(name)[0]);
		}
		if (name === 'diff') {
			alias.push('bold');
		}

		Prism.languages.diff[name] = {
			pattern: RegExp('^(?:[' + prefix + '].*(?:\r\n?|\n|(?![\\s\\S])))+', 'm'),
			alias: alias,
			inside: {
				'line': {
					pattern: /(.)(?=[\s\S]).*(?:\r\n?|\n)?/,
					lookbehind: true
				},
				'prefix': {
					pattern: /[\s\S]/,
					alias: /\w+/.exec(name)[0]
				}
			}
		};

	});

	// make prefixes available to Diff plugin
	Object.defineProperty(Prism.languages.diff, 'PREFIXES', {
		value: PREFIXES
	});

}(Prism));

(function (Prism) {

	// Many of the following regexes will contain negated lookaheads like `[ \t]+(?![ \t])`. This is a trick to ensure
	// that quantifiers behave *atomically*. Atomic quantifiers are necessary to prevent exponential backtracking.

	var spaceAfterBackSlash = /\\[\r\n](?:\s|\\[\r\n]|#.*(?!.))*(?![\s#]|\\[\r\n])/.source;
	// At least one space, comment, or line break
	var space = /(?:[ \t]+(?![ \t])(?:<SP_BS>)?|<SP_BS>)/.source
		.replace(/<SP_BS>/g, function () { return spaceAfterBackSlash; });

	var string = /"(?:[^"\\\r\n]|\\(?:\r\n|[\s\S]))*"|'(?:[^'\\\r\n]|\\(?:\r\n|[\s\S]))*'/.source;
	var option = /--[\w-]+=(?:<STR>|(?!["'])(?:[^\s\\]|\\.)+)/.source.replace(/<STR>/g, function () { return string; });

	var stringRule = {
		pattern: RegExp(string),
		greedy: true
	};
	var commentRule = {
		pattern: /(^[ \t]*)#.*/m,
		lookbehind: true,
		greedy: true
	};

	/**
	 * @param {string} source
	 * @param {string} flags
	 * @returns {RegExp}
	 */
	function re(source, flags) {
		source = source
			.replace(/<OPT>/g, function () { return option; })
			.replace(/<SP>/g, function () { return space; });

		return RegExp(source, flags);
	}

	Prism.languages.docker = {
		'instruction': {
			pattern: /(^[ \t]*)(?:ADD|ARG|CMD|COPY|ENTRYPOINT|ENV|EXPOSE|FROM|HEALTHCHECK|LABEL|MAINTAINER|ONBUILD|RUN|SHELL|STOPSIGNAL|USER|VOLUME|WORKDIR)(?=\s)(?:\\.|[^\r\n\\])*(?:\\$(?:\s|#.*$)*(?![\s#])(?:\\.|[^\r\n\\])*)*/im,
			lookbehind: true,
			greedy: true,
			inside: {
				'options': {
					pattern: re(/(^(?:ONBUILD<SP>)?\w+<SP>)<OPT>(?:<SP><OPT>)*/.source, 'i'),
					lookbehind: true,
					greedy: true,
					inside: {
						'property': {
							pattern: /(^|\s)--[\w-]+/,
							lookbehind: true
						},
						'string': [
							stringRule,
							{
								pattern: /(=)(?!["'])(?:[^\s\\]|\\.)+/,
								lookbehind: true
							}
						],
						'operator': /\\$/m,
						'punctuation': /=/
					}
				},
				'keyword': [
					{
						// https://docs.docker.com/engine/reference/builder/#healthcheck
						pattern: re(/(^(?:ONBUILD<SP>)?HEALTHCHECK<SP>(?:<OPT><SP>)*)(?:CMD|NONE)\b/.source, 'i'),
						lookbehind: true,
						greedy: true
					},
					{
						// https://docs.docker.com/engine/reference/builder/#from
						pattern: re(/(^(?:ONBUILD<SP>)?FROM<SP>(?:<OPT><SP>)*(?!--)[^ \t\\]+<SP>)AS/.source, 'i'),
						lookbehind: true,
						greedy: true
					},
					{
						// https://docs.docker.com/engine/reference/builder/#onbuild
						pattern: re(/(^ONBUILD<SP>)\w+/.source, 'i'),
						lookbehind: true,
						greedy: true
					},
					{
						pattern: /^\w+/,
						greedy: true
					}
				],
				'comment': commentRule,
				'string': stringRule,
				'variable': /\$(?:\w+|\{[^{}"'\\]*\})/,
				'operator': /\\$/m
			}
		},
		'comment': commentRule
	};

	Prism.languages.dockerfile = Prism.languages.docker;

}(Prism));

// https://www.graphviz.org/doc/info/lang.html

(function (Prism) {

	var ID = '(?:' + [
		// an identifier
		/[a-zA-Z_\x80-\uFFFF][\w\x80-\uFFFF]*/.source,
		// a number
		/-?(?:\.\d+|\d+(?:\.\d*)?)/.source,
		// a double-quoted string
		/"[^"\\]*(?:\\[\s\S][^"\\]*)*"/.source,
		// HTML-like string
		/<(?:[^<>]|(?!<!--)<(?:[^<>"']|"[^"]*"|'[^']*')+>|<!--(?:[^-]|-(?!->))*-->)*>/.source
	].join('|') + ')';

	var IDInside = {
		'markup': {
			pattern: /(^<)[\s\S]+(?=>$)/,
			lookbehind: true,
			alias: ['language-markup', 'language-html', 'language-xml'],
			inside: Prism.languages.markup
		}
	};

	/**
	 * @param {string} source
	 * @param {string} flags
	 * @returns {RegExp}
	 */
	function withID(source, flags) {
		return RegExp(source.replace(/<ID>/g, function () { return ID; }), flags);
	}

	Prism.languages.dot = {
		'comment': {
			pattern: /\/\/.*|\/\*[\s\S]*?\*\/|^#.*/m,
			greedy: true
		},
		'graph-name': {
			pattern: withID(/(\b(?:digraph|graph|subgraph)[ \t\r\n]+)<ID>/.source, 'i'),
			lookbehind: true,
			greedy: true,
			alias: 'class-name',
			inside: IDInside
		},
		'attr-value': {
			pattern: withID(/(=[ \t\r\n]*)<ID>/.source),
			lookbehind: true,
			greedy: true,
			inside: IDInside
		},
		'attr-name': {
			pattern: withID(/([\[;, \t\r\n])<ID>(?=[ \t\r\n]*=)/.source),
			lookbehind: true,
			greedy: true,
			inside: IDInside
		},
		'keyword': /\b(?:digraph|edge|graph|node|strict|subgraph)\b/i,
		'compass-point': {
			pattern: /(:[ \t\r\n]*)(?:[ewc_]|[ns][ew]?)(?![\w\x80-\uFFFF])/,
			lookbehind: true,
			alias: 'builtin'
		},
		'node': {
			pattern: withID(/(^|[^-.\w\x80-\uFFFF\\])<ID>/.source),
			lookbehind: true,
			greedy: true,
			inside: IDInside
		},
		'operator': /[=:]|-[->]/,
		'punctuation': /[\[\]{};,]/
	};

	Prism.languages.gv = Prism.languages.dot;

}(Prism));

Prism.languages.editorconfig = {
	// https://editorconfig-specification.readthedocs.io
	'comment': /[;#].*/,
	'section': {
		pattern: /(^[ \t]*)\[.+\]/m,
		lookbehind: true,
		alias: 'selector',
		inside: {
			'regex': /\\\\[\[\]{},!?.*]/, // Escape special characters with '\\'
			'operator': /[!?]|\.\.|\*{1,2}/,
			'punctuation': /[\[\]{},]/
		}
	},
	'key': {
		pattern: /(^[ \t]*)[^\s=]+(?=[ \t]*=)/m,
		lookbehind: true,
		alias: 'attr-name'
	},
	'value': {
		pattern: /=.*/,
		alias: 'attr-value',
		inside: {
			'punctuation': /^=/
		}
	}
};

Prism.languages.eiffel = {
	'comment': /--.*/,
	'string': [
		// Aligned-verbatim-strings
		{
			pattern: /"([^[]*)\[[\s\S]*?\]\1"/,
			greedy: true
		},
		// Non-aligned-verbatim-strings
		{
			pattern: /"([^{]*)\{[\s\S]*?\}\1"/,
			greedy: true
		},
		// Single-line string
		{
			pattern: /"(?:%(?:(?!\n)\s)*\n\s*%|%\S|[^%"\r\n])*"/,
			greedy: true
		}
	],
	// normal char | special char | char code
	'char': /'(?:%.|[^%'\r\n])+'/,
	'keyword': /\b(?:across|agent|alias|all|and|as|assign|attached|attribute|check|class|convert|create|Current|debug|deferred|detachable|do|else|elseif|end|ensure|expanded|export|external|feature|from|frozen|if|implies|inherit|inspect|invariant|like|local|loop|not|note|obsolete|old|once|or|Precursor|redefine|rename|require|rescue|Result|retry|select|separate|some|then|undefine|until|variant|Void|when|xor)\b/i,
	'boolean': /\b(?:False|True)\b/i,
	// Convention: class-names are always all upper-case characters
	'class-name': /\b[A-Z][\dA-Z_]*\b/,
	'number': [
		// hexa | octal | bin
		/\b0[xcb][\da-f](?:_*[\da-f])*\b/i,
		// Decimal
		/(?:\b\d(?:_*\d)*)?\.(?:(?:\d(?:_*\d)*)?e[+-]?)?\d(?:_*\d)*\b|\b\d(?:_*\d)*\b\.?/i
	],
	'punctuation': /:=|<<|>>|\(\||\|\)|->|\.(?=\w)|[{}[\];(),:?]/,
	'operator': /\\\\|\|\.\.\||\.\.|\/[~\/=]?|[><]=?|[-+*^=~]/
};

Prism.languages.elixir = {
	'doc': {
		pattern: /@(?:doc|moduledoc)\s+(?:("""|''')[\s\S]*?\1|("|')(?:\\(?:\r\n|[\s\S])|(?!\2)[^\\\r\n])*\2)/,
		inside: {
			'attribute': /^@\w+/,
			'string': /['"][\s\S]+/
		}
	},
	'comment': {
		pattern: /#.*/,
		greedy: true
	},
	// ~r"""foo""" (multi-line), ~r'''foo''' (multi-line), ~r/foo/, ~r|foo|, ~r"foo", ~r'foo', ~r(foo), ~r[foo], ~r{foo}, ~r<foo>
	'regex': {
		pattern: /~[rR](?:("""|''')(?:\\[\s\S]|(?!\1)[^\\])+\1|([\/|"'])(?:\\.|(?!\2)[^\\\r\n])+\2|\((?:\\.|[^\\)\r\n])+\)|\[(?:\\.|[^\\\]\r\n])+\]|\{(?:\\.|[^\\}\r\n])+\}|<(?:\\.|[^\\>\r\n])+>)[uismxfr]*/,
		greedy: true
	},
	'string': [
		{
			// ~s"""foo""" (multi-line), ~s'''foo''' (multi-line), ~s/foo/, ~s|foo|, ~s"foo", ~s'foo', ~s(foo), ~s[foo], ~s{foo} (with interpolation care), ~s<foo>
			pattern: /~[cCsSwW](?:("""|''')(?:\\[\s\S]|(?!\1)[^\\])+\1|([\/|"'])(?:\\.|(?!\2)[^\\\r\n])+\2|\((?:\\.|[^\\)\r\n])+\)|\[(?:\\.|[^\\\]\r\n])+\]|\{(?:\\.|#\{[^}]+\}|#(?!\{)|[^#\\}\r\n])+\}|<(?:\\.|[^\\>\r\n])+>)[csa]?/,
			greedy: true,
			inside: {
				// See interpolation below
			}
		},
		{
			pattern: /("""|''')[\s\S]*?\1/,
			greedy: true,
			inside: {
				// See interpolation below
			}
		},
		{
			// Multi-line strings are allowed
			pattern: /("|')(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1/,
			greedy: true,
			inside: {
				// See interpolation below
			}
		}
	],
	'atom': {
		// Look-behind prevents bad highlighting of the :: operator
		pattern: /(^|[^:]):\w+/,
		lookbehind: true,
		alias: 'symbol'
	},
	'module': {
		pattern: /\b[A-Z]\w*\b/,
		alias: 'class-name'
	},
	// Look-ahead prevents bad highlighting of the :: operator
	'attr-name': /\b\w+\??:(?!:)/,
	'argument': {
		// Look-behind prevents bad highlighting of the && operator
		pattern: /(^|[^&])&\d+/,
		lookbehind: true,
		alias: 'variable'
	},
	'attribute': {
		pattern: /@\w+/,
		alias: 'variable'
	},
	'function': /\b[_a-zA-Z]\w*[?!]?(?:(?=\s*(?:\.\s*)?\()|(?=\/\d))/,
	'number': /\b(?:0[box][a-f\d_]+|\d[\d_]*)(?:\.[\d_]+)?(?:e[+-]?[\d_]+)?\b/i,
	'keyword': /\b(?:after|alias|and|case|catch|cond|def(?:callback|delegate|exception|impl|macro|module|n|np|p|protocol|struct)?|do|else|end|fn|for|if|import|not|or|quote|raise|require|rescue|try|unless|unquote|use|when)\b/,
	'boolean': /\b(?:false|nil|true)\b/,
	'operator': [
		/\bin\b|&&?|\|[|>]?|\\\\|::|\.\.\.?|\+\+?|-[->]?|<[-=>]|>=|!==?|\B!|=(?:==?|[>~])?|[*\/^]/,
		{
			// We don't want to match <<
			pattern: /([^<])<(?!<)/,
			lookbehind: true
		},
		{
			// We don't want to match >>
			pattern: /([^>])>(?!>)/,
			lookbehind: true
		}
	],
	'punctuation': /<<|>>|[.,%\[\]{}()]/
};

Prism.languages.elixir.string.forEach(function (o) {
	o.inside = {
		'interpolation': {
			pattern: /#\{[^}]+\}/,
			inside: {
				'delimiter': {
					pattern: /^#\{|\}$/,
					alias: 'punctuation'
				},
				rest: Prism.languages.elixir
			}
		}
	};
});

Prism.languages.elm = {
	'comment': /--.*|\{-[\s\S]*?-\}/,
	'char': {
		pattern: /'(?:[^\\'\r\n]|\\(?:[abfnrtv\\']|\d+|x[0-9a-fA-F]+|u\{[0-9a-fA-F]+\}))'/,
		greedy: true
	},
	'string': [
		{
			// Multiline strings are wrapped in triple ". Quotes may appear unescaped.
			pattern: /"""[\s\S]*?"""/,
			greedy: true
		},
		{
			pattern: /"(?:[^\\"\r\n]|\\.)*"/,
			greedy: true
		}
	],
	'import-statement': {
		// The imported or hidden names are not included in this import
		// statement. This is because we want to highlight those exactly like
		// we do for the names in the program.
		pattern: /(^[\t ]*)import\s+[A-Z]\w*(?:\.[A-Z]\w*)*(?:\s+as\s+(?:[A-Z]\w*)(?:\.[A-Z]\w*)*)?(?:\s+exposing\s+)?/m,
		lookbehind: true,
		inside: {
			'keyword': /\b(?:as|exposing|import)\b/
		}
	},
	'keyword': /\b(?:alias|as|case|else|exposing|if|in|infixl|infixr|let|module|of|then|type)\b/,
	// These are builtin variables only. Constructors are highlighted later as a constant.
	'builtin': /\b(?:abs|acos|always|asin|atan|atan2|ceiling|clamp|compare|cos|curry|degrees|e|flip|floor|fromPolar|identity|isInfinite|isNaN|logBase|max|min|negate|never|not|pi|radians|rem|round|sin|sqrt|tan|toFloat|toPolar|toString|truncate|turns|uncurry|xor)\b/,
	// decimal integers and floating point numbers | hexadecimal integers
	'number': /\b(?:\d+(?:\.\d+)?(?:e[+-]?\d+)?|0x[0-9a-f]+)\b/i,
	// Most of this is needed because of the meaning of a single '.'.
	// If it stands alone freely, it is the function composition.
	// It may also be a separator between a module name and an identifier => no
	// operator. If it comes together with other special characters it is an
	// operator too.
	// Valid operator characters in 0.18: +-/*=.$<>:&|^?%#@~!
	// Ref: https://groups.google.com/forum/#!msg/elm-dev/0AHSnDdkSkQ/E0SVU70JEQAJ
	'operator': /\s\.\s|[+\-/*=.$<>:&|^?%#@~!]{2,}|[+\-/*=$<>:&|^?%#@~!]/,
	// In Elm, nearly everything is a variable, do not highlight these.
	'hvariable': /\b(?:[A-Z]\w*\.)*[a-z]\w*\b/,
	'constant': /\b(?:[A-Z]\w*\.)*[A-Z]\w*\b/,
	'punctuation': /[{}[\]|(),.:]/
};

Prism.languages.erlang = {
	'comment': /%.+/,
	'string': {
		pattern: /"(?:\\.|[^\\"\r\n])*"/,
		greedy: true
	},
	'quoted-function': {
		pattern: /'(?:\\.|[^\\'\r\n])+'(?=\()/,
		alias: 'function'
	},
	'quoted-atom': {
		pattern: /'(?:\\.|[^\\'\r\n])+'/,
		alias: 'atom'
	},
	'boolean': /\b(?:false|true)\b/,
	'keyword': /\b(?:after|begin|case|catch|end|fun|if|of|receive|try|when)\b/,
	'number': [
		/\$\\?./,
		/\b\d+#[a-z0-9]+/i,
		/(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:e[+-]?\d+)?/i
	],
	'function': /\b[a-z][\w@]*(?=\()/,
	'variable': {
		// Look-behind is used to prevent wrong highlighting of atoms containing "@"
		pattern: /(^|[^@])(?:\b|\?)[A-Z_][\w@]*/,
		lookbehind: true
	},
	'operator': [
		/[=\/<>:]=|=[:\/]=|\+\+?|--?|[=*\/!]|\b(?:and|andalso|band|bnot|bor|bsl|bsr|bxor|div|not|or|orelse|rem|xor)\b/,
		{
			// We don't want to match <<
			pattern: /(^|[^<])<(?!<)/,
			lookbehind: true
		},
		{
			// We don't want to match >>
			pattern: /(^|[^>])>(?!>)/,
			lookbehind: true
		}
	],
	'atom': /\b[a-z][\w@]*/,
	'punctuation': /[()[\]{}:;,.#|]|<<|>>/

};

Prism.languages.fortran = {
	'quoted-number': {
		pattern: /[BOZ](['"])[A-F0-9]+\1/i,
		alias: 'number'
	},
	'string': {
		pattern: /(?:\b\w+_)?(['"])(?:\1\1|&(?:\r\n?|\n)(?:[ \t]*!.*(?:\r\n?|\n)|(?![ \t]*!))|(?!\1).)*(?:\1|&)/,
		inside: {
			'comment': {
				pattern: /(&(?:\r\n?|\n)\s*)!.*/,
				lookbehind: true
			}
		}
	},
	'comment': {
		pattern: /!.*/,
		greedy: true
	},
	'boolean': /\.(?:FALSE|TRUE)\.(?:_\w+)?/i,
	'number': /(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:[ED][+-]?\d+)?(?:_\w+)?/i,
	'keyword': [
		// Types
		/\b(?:CHARACTER|COMPLEX|DOUBLE ?PRECISION|INTEGER|LOGICAL|REAL)\b/i,
		// END statements
		/\b(?:END ?)?(?:BLOCK ?DATA|DO|FILE|FORALL|FUNCTION|IF|INTERFACE|MODULE(?! PROCEDURE)|PROGRAM|SELECT|SUBROUTINE|TYPE|WHERE)\b/i,
		// Statements
		/\b(?:ALLOCATABLE|ALLOCATE|BACKSPACE|CALL|CASE|CLOSE|COMMON|CONTAINS|CONTINUE|CYCLE|DATA|DEALLOCATE|DIMENSION|DO|END|EQUIVALENCE|EXIT|EXTERNAL|FORMAT|GO ?TO|IMPLICIT(?: NONE)?|INQUIRE|INTENT|INTRINSIC|MODULE PROCEDURE|NAMELIST|NULLIFY|OPEN|OPTIONAL|PARAMETER|POINTER|PRINT|PRIVATE|PUBLIC|READ|RETURN|REWIND|SAVE|SELECT|STOP|TARGET|WHILE|WRITE)\b/i,
		// Others
		/\b(?:ASSIGNMENT|DEFAULT|ELEMENTAL|ELSE|ELSEIF|ELSEWHERE|ENTRY|IN|INCLUDE|INOUT|KIND|NULL|ONLY|OPERATOR|OUT|PURE|RECURSIVE|RESULT|SEQUENCE|STAT|THEN|USE)\b/i
	],
	'operator': [
		/\*\*|\/\/|=>|[=\/]=|[<>]=?|::|[+\-*=%]|\.[A-Z]+\./i,
		{
			// Use lookbehind to prevent confusion with (/ /)
			pattern: /(^|(?!\().)\/(?!\))/,
			lookbehind: true
		}
	],
	'punctuation': /\(\/|\/\)|[(),;:&]/
};

(function (Prism) {

	/**
	 * Returns the placeholder for the given language id and index.
	 *
	 * @param {string} language
	 * @param {string|number} index
	 * @returns {string}
	 */
	function getPlaceholder(language, index) {
		return '___' + language.toUpperCase() + index + '___';
	}

	Object.defineProperties(Prism.languages['markup-templating'] = {}, {
		buildPlaceholders: {
			/**
			 * Tokenize all inline templating expressions matching `placeholderPattern`.
			 *
			 * If `replaceFilter` is provided, only matches of `placeholderPattern` for which `replaceFilter` returns
			 * `true` will be replaced.
			 *
			 * @param {object} env The environment of the `before-tokenize` hook.
			 * @param {string} language The language id.
			 * @param {RegExp} placeholderPattern The matches of this pattern will be replaced by placeholders.
			 * @param {(match: string) => boolean} [replaceFilter]
			 */
			value: function (env, language, placeholderPattern, replaceFilter) {
				if (env.language !== language) {
					return;
				}

				var tokenStack = env.tokenStack = [];

				env.code = env.code.replace(placeholderPattern, function (match) {
					if (typeof replaceFilter === 'function' && !replaceFilter(match)) {
						return match;
					}
					var i = tokenStack.length;
					var placeholder;

					// Check for existing strings
					while (env.code.indexOf(placeholder = getPlaceholder(language, i)) !== -1) {
						++i;
					}

					// Create a sparse array
					tokenStack[i] = match;

					return placeholder;
				});

				// Switch the grammar to markup
				env.grammar = Prism.languages.markup;
			}
		},
		tokenizePlaceholders: {
			/**
			 * Replace placeholders with proper tokens after tokenizing.
			 *
			 * @param {object} env The environment of the `after-tokenize` hook.
			 * @param {string} language The language id.
			 */
			value: function (env, language) {
				if (env.language !== language || !env.tokenStack) {
					return;
				}

				// Switch the grammar back
				env.grammar = Prism.languages[language];

				var j = 0;
				var keys = Object.keys(env.tokenStack);

				function walkTokens(tokens) {
					for (var i = 0; i < tokens.length; i++) {
						// all placeholders are replaced already
						if (j >= keys.length) {
							break;
						}

						var token = tokens[i];
						if (typeof token === 'string' || (token.content && typeof token.content === 'string')) {
							var k = keys[j];
							var t = env.tokenStack[k];
							var s = typeof token === 'string' ? token : token.content;
							var placeholder = getPlaceholder(language, k);

							var index = s.indexOf(placeholder);
							if (index > -1) {
								++j;

								var before = s.substring(0, index);
								var middle = new Prism.Token(language, Prism.tokenize(t, env.grammar), 'language-' + language, t);
								var after = s.substring(index + placeholder.length);

								var replacement = [];
								if (before) {
									replacement.push.apply(replacement, walkTokens([before]));
								}
								replacement.push(middle);
								if (after) {
									replacement.push.apply(replacement, walkTokens([after]));
								}

								if (typeof token === 'string') {
									tokens.splice.apply(tokens, [i, 1].concat(replacement));
								} else {
									token.content = replacement;
								}
							}
						} else if (token.content /* && typeof token.content !== 'string' */) {
							walkTokens(token.content);
						}
					}

					return tokens;
				}

				walkTokens(env.tokens);
			}
		}
	});

}(Prism));

(function (Prism) {

	// https://freemarker.apache.org/docs/dgui_template_exp.html

	// FTL expression with 4 levels of nesting supported
	var FTL_EXPR = /[^<()"']|\((?:<expr>)*\)|<(?!#--)|<#--(?:[^-]|-(?!->))*-->|"(?:[^\\"]|\\.)*"|'(?:[^\\']|\\.)*'/.source;
	for (var i = 0; i < 2; i++) {
		FTL_EXPR = FTL_EXPR.replace(/<expr>/g, function () { return FTL_EXPR; });
	}
	FTL_EXPR = FTL_EXPR.replace(/<expr>/g, /[^\s\S]/.source);

	var ftl = {
		'comment': /<#--[\s\S]*?-->/,
		'string': [
			{
				// raw string
				pattern: /\br("|')(?:(?!\1)[^\\]|\\.)*\1/,
				greedy: true
			},
			{
				pattern: RegExp(/("|')(?:(?!\1|\$\{)[^\\]|\\.|\$\{(?:(?!\})(?:<expr>))*\})*\1/.source.replace(/<expr>/g, function () { return FTL_EXPR; })),
				greedy: true,
				inside: {
					'interpolation': {
						pattern: RegExp(/((?:^|[^\\])(?:\\\\)*)\$\{(?:(?!\})(?:<expr>))*\}/.source.replace(/<expr>/g, function () { return FTL_EXPR; })),
						lookbehind: true,
						inside: {
							'interpolation-punctuation': {
								pattern: /^\$\{|\}$/,
								alias: 'punctuation'
							},
							rest: null
						}
					}
				}
			}
		],
		'keyword': /\b(?:as)\b/,
		'boolean': /\b(?:false|true)\b/,
		'builtin-function': {
			pattern: /((?:^|[^?])\?\s*)\w+/,
			lookbehind: true,
			alias: 'function'
		},
		'function': /\b\w+(?=\s*\()/,
		'number': /\b\d+(?:\.\d+)?\b/,
		'operator': /\.\.[<*!]?|->|--|\+\+|&&|\|\||\?{1,2}|[-+*/%!=<>]=?|\b(?:gt|gte|lt|lte)\b/,
		'punctuation': /[,;.:()[\]{}]/
	};

	ftl.string[1].inside.interpolation.inside.rest = ftl;

	Prism.languages.ftl = {
		'ftl-comment': {
			// the pattern is shortened to be more efficient
			pattern: /^<#--[\s\S]*/,
			alias: 'comment'
		},
		'ftl-directive': {
			pattern: /^<[\s\S]+>$/,
			inside: {
				'directive': {
					pattern: /(^<\/?)[#@][a-z]\w*/i,
					lookbehind: true,
					alias: 'keyword'
				},
				'punctuation': /^<\/?|\/?>$/,
				'content': {
					pattern: /\s*\S[\s\S]*/,
					alias: 'ftl',
					inside: ftl
				}
			}
		},
		'ftl-interpolation': {
			pattern: /^\$\{[\s\S]*\}$/,
			inside: {
				'punctuation': /^\$\{|\}$/,
				'content': {
					pattern: /\s*\S[\s\S]*/,
					alias: 'ftl',
					inside: ftl
				}
			}
		}
	};

	Prism.hooks.add('before-tokenize', function (env) {
		// eslint-disable-next-line regexp/no-useless-lazy
		var pattern = RegExp(/<#--[\s\S]*?-->|<\/?[#@][a-zA-Z](?:<expr>)*?>|\$\{(?:<expr>)*?\}/.source.replace(/<expr>/g, function () { return FTL_EXPR; }), 'gi');
		Prism.languages['markup-templating'].buildPlaceholders(env, 'ftl', pattern);
	});

	Prism.hooks.add('after-tokenize', function (env) {
		Prism.languages['markup-templating'].tokenizePlaceholders(env, 'ftl');
	});

}(Prism));

Prism.languages.go = Prism.languages.extend('clike', {
	'string': {
		pattern: /(^|[^\\])"(?:\\.|[^"\\\r\n])*"|`[^`]*`/,
		lookbehind: true,
		greedy: true
	},
	'keyword': /\b(?:break|case|chan|const|continue|default|defer|else|fallthrough|for|func|go(?:to)?|if|import|interface|map|package|range|return|select|struct|switch|type|var)\b/,
	'boolean': /\b(?:_|false|iota|nil|true)\b/,
	'number': [
		// binary and octal integers
		/\b0(?:b[01_]+|o[0-7_]+)i?\b/i,
		// hexadecimal integers and floats
		/\b0x(?:[a-f\d_]+(?:\.[a-f\d_]*)?|\.[a-f\d_]+)(?:p[+-]?\d+(?:_\d+)*)?i?(?!\w)/i,
		// decimal integers and floats
		/(?:\b\d[\d_]*(?:\.[\d_]*)?|\B\.\d[\d_]*)(?:e[+-]?[\d_]+)?i?(?!\w)/i
	],
	'operator': /[*\/%^!=]=?|\+[=+]?|-[=-]?|\|[=|]?|&(?:=|&|\^=?)?|>(?:>=?|=)?|<(?:<=?|=|-)?|:=|\.\.\./,
	'builtin': /\b(?:append|bool|byte|cap|close|complex|complex(?:64|128)|copy|delete|error|float(?:32|64)|u?int(?:8|16|32|64)?|imag|len|make|new|panic|print(?:ln)?|real|recover|rune|string|uintptr)\b/
});

Prism.languages.insertBefore('go', 'string', {
	'char': {
		pattern: /'(?:\\.|[^'\\\r\n]){0,10}'/,
		greedy: true
	}
});

delete Prism.languages.go['class-name'];

// https://go.dev/ref/mod#go-mod-file-module

Prism.languages['go-mod'] = Prism.languages['go-module'] = {
	'comment': {
		pattern: /\/\/.*/,
		greedy: true
	},
	'version': {
		pattern: /(^|[\s()[\],])v\d+\.\d+\.\d+(?:[+-][-+.\w]*)?(?![^\s()[\],])/,
		lookbehind: true,
		alias: 'number'
	},
	'go-version': {
		pattern: /((?:^|\s)go\s+)\d+(?:\.\d+){1,2}/,
		lookbehind: true,
		alias: 'number'
	},
	'keyword': {
		pattern: /^([ \t]*)(?:exclude|go|module|replace|require|retract)\b/m,
		lookbehind: true
	},
	'operator': /=>/,
	'punctuation': /[()[\],]/
};

(function (Prism) {
	var interpolation = {
		pattern: /((?:^|[^\\$])(?:\\{2})*)\$(?:\w+|\{[^{}]*\})/,
		lookbehind: true,
		inside: {
			'interpolation-punctuation': {
				pattern: /^\$\{?|\}$/,
				alias: 'punctuation',
			},
			'expression': {
				pattern: /[\s\S]+/,
				inside: null,
			},
		},
	};

	Prism.languages.gradle = Prism.languages.extend('clike', {
		'string': {
			pattern: /'''(?:[^\\]|\\[\s\S])*?'''|'(?:\\.|[^\\'\r\n])*'/,
			greedy: true,
		},
		'keyword':
			/\b(?:apply|def|dependencies|else|if|implementation|import|plugin|plugins|project|repositories|repository|sourceSets|tasks|val)\b/,
		'number': /\b(?:0b[01_]+|0x[\da-f_]+(?:\.[\da-f_p\-]+)?|[\d_]+(?:\.[\d_]+)?(?:e[+-]?\d+)?)[glidf]?\b/i,
		'operator': {
			pattern:
				/(^|[^.])(?:~|==?~?|\?[.:]?|\*(?:[.=]|\*=?)?|\.[@&]|\.\.<|\.\.(?!\.)|-[-=>]?|\+[+=]?|!=?|<(?:<=?|=>?)?|>(?:>>?=?|=)?|&[&=]?|\|[|=]?|\/=?|\^=?|%=?)/,
			lookbehind: true,
		},
		'punctuation': /\.+|[{}[\];(),:$]/,
	});

	Prism.languages.insertBefore('gradle', 'string', {
		'shebang': {
			pattern: /#!.+/,
			alias: 'comment',
			greedy: true,
		},
		'interpolation-string': {
			pattern:
				/"""(?:[^\\]|\\[\s\S])*?"""|(["/])(?:\\.|(?!\1)[^\\\r\n])*\1|\$\/(?:[^/$]|\$(?:[/$]|(?![/$]))|\/(?!\$))*\/\$/,
			greedy: true,
			inside: {
				'interpolation': interpolation,
				'string': /[\s\S]+/,
			},
		},
	});

	Prism.languages.insertBefore('gradle', 'punctuation', {
		'spock-block': /\b(?:and|cleanup|expect|given|setup|then|when|where):/,
	});

	Prism.languages.insertBefore('gradle', 'function', {
		'annotation': {
			pattern: /(^|[^.])@\w+/,
			lookbehind: true,
			alias: 'punctuation',
		},
	});

	interpolation.inside.expression.inside = Prism.languages.gradle;
}(Prism));

Prism.languages.graphql = {
	'comment': /#.*/,
	'description': {
		pattern: /(?:"""(?:[^"]|(?!""")")*"""|"(?:\\.|[^\\"\r\n])*")(?=\s*[a-z_])/i,
		greedy: true,
		alias: 'string',
		inside: {
			'language-markdown': {
				pattern: /(^"(?:"")?)(?!\1)[\s\S]+(?=\1$)/,
				lookbehind: true,
				inside: Prism.languages.markdown
			}
		}
	},
	'string': {
		pattern: /"""(?:[^"]|(?!""")")*"""|"(?:\\.|[^\\"\r\n])*"/,
		greedy: true
	},
	'number': /(?:\B-|\b)\d+(?:\.\d+)?(?:e[+-]?\d+)?\b/i,
	'boolean': /\b(?:false|true)\b/,
	'variable': /\$[a-z_]\w*/i,
	'directive': {
		pattern: /@[a-z_]\w*/i,
		alias: 'function'
	},
	'attr-name': {
		pattern: /\b[a-z_]\w*(?=\s*(?:\((?:[^()"]|"(?:\\.|[^\\"\r\n])*")*\))?:)/i,
		greedy: true
	},
	'atom-input': {
		pattern: /\b[A-Z]\w*Input\b/,
		alias: 'class-name'
	},
	'scalar': /\b(?:Boolean|Float|ID|Int|String)\b/,
	'constant': /\b[A-Z][A-Z_\d]*\b/,
	'class-name': {
		pattern: /(\b(?:enum|implements|interface|on|scalar|type|union)\s+|&\s*|:\s*|\[)[A-Z_]\w*/,
		lookbehind: true
	},
	'fragment': {
		pattern: /(\bfragment\s+|\.{3}\s*(?!on\b))[a-zA-Z_]\w*/,
		lookbehind: true,
		alias: 'function'
	},
	'definition-mutation': {
		pattern: /(\bmutation\s+)[a-zA-Z_]\w*/,
		lookbehind: true,
		alias: 'function'
	},
	'definition-query': {
		pattern: /(\bquery\s+)[a-zA-Z_]\w*/,
		lookbehind: true,
		alias: 'function'
	},
	'keyword': /\b(?:directive|enum|extend|fragment|implements|input|interface|mutation|on|query|repeatable|scalar|schema|subscription|type|union)\b/,
	'operator': /[!=|&]|\.{3}/,
	'property-query': /\w+(?=\s*\()/,
	'object': /\w+(?=\s*\{)/,
	'punctuation': /[!(){}\[\]:=,]/,
	'property': /\w+/
};

Prism.hooks.add('after-tokenize', function afterTokenizeGraphql(env) {
	if (env.language !== 'graphql') {
		return;
	}

	/**
	 * get the graphql token stream that we want to customize
	 *
	 * @typedef {InstanceType<import("./prism-core")["Token"]>} Token
	 * @type {Token[]}
	 */
	var validTokens = env.tokens.filter(function (token) {
		return typeof token !== 'string' && token.type !== 'comment' && token.type !== 'scalar';
	});

	var currentIndex = 0;

	/**
	 * Returns whether the token relative to the current index has the given type.
	 *
	 * @param {number} offset
	 * @returns {Token | undefined}
	 */
	function getToken(offset) {
		return validTokens[currentIndex + offset];
	}

	/**
	 * Returns whether the token relative to the current index has the given type.
	 *
	 * @param {readonly string[]} types
	 * @param {number} [offset=0]
	 * @returns {boolean}
	 */
	function isTokenType(types, offset) {
		offset = offset || 0;
		for (var i = 0; i < types.length; i++) {
			var token = getToken(i + offset);
			if (!token || token.type !== types[i]) {
				return false;
			}
		}
		return true;
	}

	/**
	 * Returns the index of the closing bracket to an opening bracket.
	 *
	 * It is assumed that `token[currentIndex - 1]` is an opening bracket.
	 *
	 * If no closing bracket could be found, `-1` will be returned.
	 *
	 * @param {RegExp} open
	 * @param {RegExp} close
	 * @returns {number}
	 */
	function findClosingBracket(open, close) {
		var stackHeight = 1;

		for (var i = currentIndex; i < validTokens.length; i++) {
			var token = validTokens[i];
			var content = token.content;

			if (token.type === 'punctuation' && typeof content === 'string') {
				if (open.test(content)) {
					stackHeight++;
				} else if (close.test(content)) {
					stackHeight--;

					if (stackHeight === 0) {
						return i;
					}
				}
			}
		}

		return -1;
	}

	/**
	 * Adds an alias to the given token.
	 *
	 * @param {Token} token
	 * @param {string} alias
	 * @returns {void}
	 */
	function addAlias(token, alias) {
		var aliases = token.alias;
		if (!aliases) {
			token.alias = aliases = [];
		} else if (!Array.isArray(aliases)) {
			token.alias = aliases = [aliases];
		}
		aliases.push(alias);
	}

	for (; currentIndex < validTokens.length;) {
		var startToken = validTokens[currentIndex++];

		// add special aliases for mutation tokens
		if (startToken.type === 'keyword' && startToken.content === 'mutation') {
			// any array of the names of all input variables (if any)
			var inputVariables = [];

			if (isTokenType(['definition-mutation', 'punctuation']) && getToken(1).content === '(') {
				// definition

				currentIndex += 2; // skip 'definition-mutation' and 'punctuation'

				var definitionEnd = findClosingBracket(/^\($/, /^\)$/);
				if (definitionEnd === -1) {
					continue;
				}

				// find all input variables
				for (; currentIndex < definitionEnd; currentIndex++) {
					var t = getToken(0);
					if (t.type === 'variable') {
						addAlias(t, 'variable-input');
						inputVariables.push(t.content);
					}
				}

				currentIndex = definitionEnd + 1;
			}

			if (isTokenType(['punctuation', 'property-query']) && getToken(0).content === '{') {
				currentIndex++; // skip opening bracket

				addAlias(getToken(0), 'property-mutation');

				if (inputVariables.length > 0) {
					var mutationEnd = findClosingBracket(/^\{$/, /^\}$/);
					if (mutationEnd === -1) {
						continue;
					}

					// give references to input variables a special alias
					for (var i = currentIndex; i < mutationEnd; i++) {
						var varToken = validTokens[i];
						if (varToken.type === 'variable' && inputVariables.indexOf(varToken.content) >= 0) {
							addAlias(varToken, 'variable-input');
						}
					}
				}
			}
		}
	}
});

(function (Prism) {

	var interpolation = {
		pattern: /((?:^|[^\\$])(?:\\{2})*)\$(?:\w+|\{[^{}]*\})/,
		lookbehind: true,
		inside: {
			'interpolation-punctuation': {
				pattern: /^\$\{?|\}$/,
				alias: 'punctuation'
			},
			'expression': {
				pattern: /[\s\S]+/,
				inside: null // see below
			}
		}
	};

	Prism.languages.groovy = Prism.languages.extend('clike', {
		'string': {
			// https://groovy-lang.org/syntax.html#_dollar_slashy_string
			pattern: /'''(?:[^\\]|\\[\s\S])*?'''|'(?:\\.|[^\\'\r\n])*'/,
			greedy: true
		},
		'keyword': /\b(?:abstract|as|assert|boolean|break|byte|case|catch|char|class|const|continue|def|default|do|double|else|enum|extends|final|finally|float|for|goto|if|implements|import|in|instanceof|int|interface|long|native|new|package|private|protected|public|return|short|static|strictfp|super|switch|synchronized|this|throw|throws|trait|transient|try|void|volatile|while)\b/,
		'number': /\b(?:0b[01_]+|0x[\da-f_]+(?:\.[\da-f_p\-]+)?|[\d_]+(?:\.[\d_]+)?(?:e[+-]?\d+)?)[glidf]?\b/i,
		'operator': {
			pattern: /(^|[^.])(?:~|==?~?|\?[.:]?|\*(?:[.=]|\*=?)?|\.[@&]|\.\.<|\.\.(?!\.)|-[-=>]?|\+[+=]?|!=?|<(?:<=?|=>?)?|>(?:>>?=?|=)?|&[&=]?|\|[|=]?|\/=?|\^=?|%=?)/,
			lookbehind: true
		},
		'punctuation': /\.+|[{}[\];(),:$]/
	});

	Prism.languages.insertBefore('groovy', 'string', {
		'shebang': {
			pattern: /#!.+/,
			alias: 'comment',
			greedy: true
		},
		'interpolation-string': {
			// TODO: Slash strings (e.g. /foo/) can contain line breaks but this will cause a lot of trouble with
			// simple division (see JS regex), so find a fix maybe?
			pattern: /"""(?:[^\\]|\\[\s\S])*?"""|(["/])(?:\\.|(?!\1)[^\\\r\n])*\1|\$\/(?:[^/$]|\$(?:[/$]|(?![/$]))|\/(?!\$))*\/\$/,
			greedy: true,
			inside: {
				'interpolation': interpolation,
				'string': /[\s\S]+/
			}
		}
	});

	Prism.languages.insertBefore('groovy', 'punctuation', {
		'spock-block': /\b(?:and|cleanup|expect|given|setup|then|when|where):/
	});

	Prism.languages.insertBefore('groovy', 'function', {
		'annotation': {
			pattern: /(^|[^.])@\w+/,
			lookbehind: true,
			alias: 'punctuation'
		}
	});

	interpolation.inside.expression.inside = Prism.languages.groovy;

}(Prism));

/**
 * Original by Samuel Flores
 *
 * Adds the following new token classes:
 *     constant, builtin, variable, symbol, regex
 */
(function (Prism) {
	Prism.languages.ruby = Prism.languages.extend('clike', {
		'comment': {
			pattern: /#.*|^=begin\s[\s\S]*?^=end/m,
			greedy: true
		},
		'class-name': {
			pattern: /(\b(?:class|module)\s+|\bcatch\s+\()[\w.\\]+|\b[A-Z_]\w*(?=\s*\.\s*new\b)/,
			lookbehind: true,
			inside: {
				'punctuation': /[.\\]/
			}
		},
		'keyword': /\b(?:BEGIN|END|alias|and|begin|break|case|class|def|define_method|defined|do|each|else|elsif|end|ensure|extend|for|if|in|include|module|new|next|nil|not|or|prepend|private|protected|public|raise|redo|require|rescue|retry|return|self|super|then|throw|undef|unless|until|when|while|yield)\b/,
		'operator': /\.{2,3}|&\.|===|<?=>|[!=]?~|(?:&&|\|\||<<|>>|\*\*|[+\-*/%<>!^&|=])=?|[?:]/,
		'punctuation': /[(){}[\].,;]/,
	});

	Prism.languages.insertBefore('ruby', 'operator', {
		'double-colon': {
			pattern: /::/,
			alias: 'punctuation'
		},
	});

	var interpolation = {
		pattern: /((?:^|[^\\])(?:\\{2})*)#\{(?:[^{}]|\{[^{}]*\})*\}/,
		lookbehind: true,
		inside: {
			'content': {
				pattern: /^(#\{)[\s\S]+(?=\}$)/,
				lookbehind: true,
				inside: Prism.languages.ruby
			},
			'delimiter': {
				pattern: /^#\{|\}$/,
				alias: 'punctuation'
			}
		}
	};

	delete Prism.languages.ruby.function;

	var percentExpression = '(?:' + [
		/([^a-zA-Z0-9\s{(\[<=])(?:(?!\1)[^\\]|\\[\s\S])*\1/.source,
		/\((?:[^()\\]|\\[\s\S]|\((?:[^()\\]|\\[\s\S])*\))*\)/.source,
		/\{(?:[^{}\\]|\\[\s\S]|\{(?:[^{}\\]|\\[\s\S])*\})*\}/.source,
		/\[(?:[^\[\]\\]|\\[\s\S]|\[(?:[^\[\]\\]|\\[\s\S])*\])*\]/.source,
		/<(?:[^<>\\]|\\[\s\S]|<(?:[^<>\\]|\\[\s\S])*>)*>/.source
	].join('|') + ')';

	var symbolName = /(?:"(?:\\.|[^"\\\r\n])*"|(?:\b[a-zA-Z_]\w*|[^\s\0-\x7F]+)[?!]?|\$.)/.source;

	Prism.languages.insertBefore('ruby', 'keyword', {
		'regex-literal': [
			{
				pattern: RegExp(/%r/.source + percentExpression + /[egimnosux]{0,6}/.source),
				greedy: true,
				inside: {
					'interpolation': interpolation,
					'regex': /[\s\S]+/
				}
			},
			{
				pattern: /(^|[^/])\/(?!\/)(?:\[[^\r\n\]]+\]|\\.|[^[/\\\r\n])+\/[egimnosux]{0,6}(?=\s*(?:$|[\r\n,.;})#]))/,
				lookbehind: true,
				greedy: true,
				inside: {
					'interpolation': interpolation,
					'regex': /[\s\S]+/
				}
			}
		],
		'variable': /[@$]+[a-zA-Z_]\w*(?:[?!]|\b)/,
		'symbol': [
			{
				pattern: RegExp(/(^|[^:]):/.source + symbolName),
				lookbehind: true,
				greedy: true
			},
			{
				pattern: RegExp(/([\r\n{(,][ \t]*)/.source + symbolName + /(?=:(?!:))/.source),
				lookbehind: true,
				greedy: true
			},
		],
		'method-definition': {
			pattern: /(\bdef\s+)\w+(?:\s*\.\s*\w+)?/,
			lookbehind: true,
			inside: {
				'function': /\b\w+$/,
				'keyword': /^self\b/,
				'class-name': /^\w+/,
				'punctuation': /\./
			}
		}
	});

	Prism.languages.insertBefore('ruby', 'string', {
		'string-literal': [
			{
				pattern: RegExp(/%[qQiIwWs]?/.source + percentExpression),
				greedy: true,
				inside: {
					'interpolation': interpolation,
					'string': /[\s\S]+/
				}
			},
			{
				pattern: /("|')(?:#\{[^}]+\}|#(?!\{)|\\(?:\r\n|[\s\S])|(?!\1)[^\\#\r\n])*\1/,
				greedy: true,
				inside: {
					'interpolation': interpolation,
					'string': /[\s\S]+/
				}
			},
			{
				pattern: /<<[-~]?([a-z_]\w*)[\r\n](?:.*[\r\n])*?[\t ]*\1/i,
				alias: 'heredoc-string',
				greedy: true,
				inside: {
					'delimiter': {
						pattern: /^<<[-~]?[a-z_]\w*|\b[a-z_]\w*$/i,
						inside: {
							'symbol': /\b\w+/,
							'punctuation': /^<<[-~]?/
						}
					},
					'interpolation': interpolation,
					'string': /[\s\S]+/
				}
			},
			{
				pattern: /<<[-~]?'([a-z_]\w*)'[\r\n](?:.*[\r\n])*?[\t ]*\1/i,
				alias: 'heredoc-string',
				greedy: true,
				inside: {
					'delimiter': {
						pattern: /^<<[-~]?'[a-z_]\w*'|\b[a-z_]\w*$/i,
						inside: {
							'symbol': /\b\w+/,
							'punctuation': /^<<[-~]?'|'$/,
						}
					},
					'string': /[\s\S]+/
				}
			}
		],
		'command-literal': [
			{
				pattern: RegExp(/%x/.source + percentExpression),
				greedy: true,
				inside: {
					'interpolation': interpolation,
					'command': {
						pattern: /[\s\S]+/,
						alias: 'string'
					}
				}
			},
			{
				pattern: /`(?:#\{[^}]+\}|#(?!\{)|\\(?:\r\n|[\s\S])|[^\\`#\r\n])*`/,
				greedy: true,
				inside: {
					'interpolation': interpolation,
					'command': {
						pattern: /[\s\S]+/,
						alias: 'string'
					}
				}
			}
		]
	});

	delete Prism.languages.ruby.string;

	Prism.languages.insertBefore('ruby', 'number', {
		'builtin': /\b(?:Array|Bignum|Binding|Class|Continuation|Dir|Exception|FalseClass|File|Fixnum|Float|Hash|IO|Integer|MatchData|Method|Module|NilClass|Numeric|Object|Proc|Range|Regexp|Stat|String|Struct|Symbol|TMS|Thread|ThreadGroup|Time|TrueClass)\b/,
		'constant': /\b[A-Z][A-Z0-9_]*(?:[?!]|\b)/
	});

	Prism.languages.rb = Prism.languages.ruby;
}(Prism));

/* TODO
	Handle multiline code after tag
	    %foo= some |
			multiline |
			code |
*/

(function (Prism) {

	Prism.languages.haml = {
		// Multiline stuff should appear before the rest

		'multiline-comment': {
			pattern: /((?:^|\r?\n|\r)([\t ]*))(?:\/|-#).*(?:(?:\r?\n|\r)\2[\t ].+)*/,
			lookbehind: true,
			alias: 'comment'
		},

		'multiline-code': [
			{
				pattern: /((?:^|\r?\n|\r)([\t ]*)(?:[~-]|[&!]?=)).*,[\t ]*(?:(?:\r?\n|\r)\2[\t ].*,[\t ]*)*(?:(?:\r?\n|\r)\2[\t ].+)/,
				lookbehind: true,
				inside: Prism.languages.ruby
			},
			{
				pattern: /((?:^|\r?\n|\r)([\t ]*)(?:[~-]|[&!]?=)).*\|[\t ]*(?:(?:\r?\n|\r)\2[\t ].*\|[\t ]*)*/,
				lookbehind: true,
				inside: Prism.languages.ruby
			}
		],

		// See at the end of the file for known filters
		'filter': {
			pattern: /((?:^|\r?\n|\r)([\t ]*)):[\w-]+(?:(?:\r?\n|\r)(?:\2[\t ].+|\s*?(?=\r?\n|\r)))+/,
			lookbehind: true,
			inside: {
				'filter-name': {
					pattern: /^:[\w-]+/,
					alias: 'symbol'
				}
			}
		},

		'markup': {
			pattern: /((?:^|\r?\n|\r)[\t ]*)<.+/,
			lookbehind: true,
			inside: Prism.languages.markup
		},
		'doctype': {
			pattern: /((?:^|\r?\n|\r)[\t ]*)!!!(?: .+)?/,
			lookbehind: true
		},
		'tag': {
			// Allows for one nested group of braces
			pattern: /((?:^|\r?\n|\r)[\t ]*)[%.#][\w\-#.]*[\w\-](?:\([^)]+\)|\{(?:\{[^}]+\}|[^{}])+\}|\[[^\]]+\])*[\/<>]*/,
			lookbehind: true,
			inside: {
				'attributes': [
					{
						// Lookbehind tries to prevent interpolations from breaking it all
						// Allows for one nested group of braces
						pattern: /(^|[^#])\{(?:\{[^}]+\}|[^{}])+\}/,
						lookbehind: true,
						inside: Prism.languages.ruby
					},
					{
						pattern: /\([^)]+\)/,
						inside: {
							'attr-value': {
								pattern: /(=\s*)(?:"(?:\\.|[^\\"\r\n])*"|[^)\s]+)/,
								lookbehind: true
							},
							'attr-name': /[\w:-]+(?=\s*!?=|\s*[,)])/,
							'punctuation': /[=(),]/
						}
					},
					{
						pattern: /\[[^\]]+\]/,
						inside: Prism.languages.ruby
					}
				],
				'punctuation': /[<>]/
			}
		},
		'code': {
			pattern: /((?:^|\r?\n|\r)[\t ]*(?:[~-]|[&!]?=)).+/,
			lookbehind: true,
			inside: Prism.languages.ruby
		},
		// Interpolations in plain text
		'interpolation': {
			pattern: /#\{[^}]+\}/,
			inside: {
				'delimiter': {
					pattern: /^#\{|\}$/,
					alias: 'punctuation'
				},
				'ruby': {
					pattern: /[\s\S]+/,
					inside: Prism.languages.ruby
				}
			}
		},
		'punctuation': {
			pattern: /((?:^|\r?\n|\r)[\t ]*)[~=\-&!]+/,
			lookbehind: true
		}
	};

	var filter_pattern = '((?:^|\\r?\\n|\\r)([\\t ]*)):{{filter_name}}(?:(?:\\r?\\n|\\r)(?:\\2[\\t ].+|\\s*?(?=\\r?\\n|\\r)))+';

	// Non exhaustive list of available filters and associated languages
	var filters = [
		'css',
		{ filter: 'coffee', language: 'coffeescript' },
		'erb',
		'javascript',
		'less',
		'markdown',
		'ruby',
		'scss',
		'textile'
	];
	var all_filters = {};
	for (var i = 0, l = filters.length; i < l; i++) {
		var filter = filters[i];
		filter = typeof filter === 'string' ? { filter: filter, language: filter } : filter;
		if (Prism.languages[filter.language]) {
			all_filters['filter-' + filter.filter] = {
				pattern: RegExp(filter_pattern.replace('{{filter_name}}', function () { return filter.filter; })),
				lookbehind: true,
				inside: {
					'filter-name': {
						pattern: /^:[\w-]+/,
						alias: 'symbol'
					},
					'text': {
						pattern: /[\s\S]+/,
						alias: [filter.language, 'language-' + filter.language],
						inside: Prism.languages[filter.language]
					}
				}
			};
		}
	}

	Prism.languages.insertBefore('haml', 'filter', all_filters);

}(Prism));

(function (Prism) {

	Prism.languages.handlebars = {
		'comment': /\{\{![\s\S]*?\}\}/,
		'delimiter': {
			pattern: /^\{\{\{?|\}\}\}?$/,
			alias: 'punctuation'
		},
		'string': /(["'])(?:\\.|(?!\1)[^\\\r\n])*\1/,
		'number': /\b0x[\dA-Fa-f]+\b|(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:[Ee][+-]?\d+)?/,
		'boolean': /\b(?:false|true)\b/,
		'block': {
			pattern: /^(\s*(?:~\s*)?)[#\/]\S+?(?=\s*(?:~\s*)?$|\s)/,
			lookbehind: true,
			alias: 'keyword'
		},
		'brackets': {
			pattern: /\[[^\]]+\]/,
			inside: {
				punctuation: /\[|\]/,
				variable: /[\s\S]+/
			}
		},
		'punctuation': /[!"#%&':()*+,.\/;<=>@\[\\\]^`{|}~]/,
		'variable': /[^!"#%&'()*+,\/;<=>@\[\\\]^`{|}~\s]+/
	};

	Prism.hooks.add('before-tokenize', function (env) {
		var handlebarsPattern = /\{\{\{[\s\S]+?\}\}\}|\{\{[\s\S]+?\}\}/g;
		Prism.languages['markup-templating'].buildPlaceholders(env, 'handlebars', handlebarsPattern);
	});

	Prism.hooks.add('after-tokenize', function (env) {
		Prism.languages['markup-templating'].tokenizePlaceholders(env, 'handlebars');
	});

	Prism.languages.hbs = Prism.languages.handlebars;
	Prism.languages.mustache = Prism.languages.handlebars;

}(Prism));

Prism.languages.haskell = {
	'comment': {
		pattern: /(^|[^-!#$%*+=?&@|~.:<>^\\\/])(?:--(?:(?=.)[^-!#$%*+=?&@|~.:<>^\\\/].*|$)|\{-[\s\S]*?-\})/m,
		lookbehind: true
	},
	'char': {
		pattern: /'(?:[^\\']|\\(?:[abfnrtv\\"'&]|\^[A-Z@[\]^_]|ACK|BEL|BS|CAN|CR|DC1|DC2|DC3|DC4|DEL|DLE|EM|ENQ|EOT|ESC|ETB|ETX|FF|FS|GS|HT|LF|NAK|NUL|RS|SI|SO|SOH|SP|STX|SUB|SYN|US|VT|\d+|o[0-7]+|x[0-9a-fA-F]+))'/,
		alias: 'string'
	},
	'string': {
		pattern: /"(?:[^\\"]|\\(?:\S|\s+\\))*"/,
		greedy: true
	},
	'keyword': /\b(?:case|class|data|deriving|do|else|if|in|infixl|infixr|instance|let|module|newtype|of|primitive|then|type|where)\b/,
	'import-statement': {
		// The imported or hidden names are not included in this import
		// statement. This is because we want to highlight those exactly like
		// we do for the names in the program.
		pattern: /(^[\t ]*)import\s+(?:qualified\s+)?(?:[A-Z][\w']*)(?:\.[A-Z][\w']*)*(?:\s+as\s+(?:[A-Z][\w']*)(?:\.[A-Z][\w']*)*)?(?:\s+hiding\b)?/m,
		lookbehind: true,
		inside: {
			'keyword': /\b(?:as|hiding|import|qualified)\b/,
			'punctuation': /\./
		}
	},
	// These are builtin variables only. Constructors are highlighted later as a constant.
	'builtin': /\b(?:abs|acos|acosh|all|and|any|appendFile|approxRational|asTypeOf|asin|asinh|atan|atan2|atanh|basicIORun|break|catch|ceiling|chr|compare|concat|concatMap|const|cos|cosh|curry|cycle|decodeFloat|denominator|digitToInt|div|divMod|drop|dropWhile|either|elem|encodeFloat|enumFrom|enumFromThen|enumFromThenTo|enumFromTo|error|even|exp|exponent|fail|filter|flip|floatDigits|floatRadix|floatRange|floor|fmap|foldl|foldl1|foldr|foldr1|fromDouble|fromEnum|fromInt|fromInteger|fromIntegral|fromRational|fst|gcd|getChar|getContents|getLine|group|head|id|inRange|index|init|intToDigit|interact|ioError|isAlpha|isAlphaNum|isAscii|isControl|isDenormalized|isDigit|isHexDigit|isIEEE|isInfinite|isLower|isNaN|isNegativeZero|isOctDigit|isPrint|isSpace|isUpper|iterate|last|lcm|length|lex|lexDigits|lexLitChar|lines|log|logBase|lookup|map|mapM|mapM_|max|maxBound|maximum|maybe|min|minBound|minimum|mod|negate|not|notElem|null|numerator|odd|or|ord|otherwise|pack|pi|pred|primExitWith|print|product|properFraction|putChar|putStr|putStrLn|quot|quotRem|range|rangeSize|read|readDec|readFile|readFloat|readHex|readIO|readInt|readList|readLitChar|readLn|readOct|readParen|readSigned|reads|readsPrec|realToFrac|recip|rem|repeat|replicate|return|reverse|round|scaleFloat|scanl|scanl1|scanr|scanr1|seq|sequence|sequence_|show|showChar|showInt|showList|showLitChar|showParen|showSigned|showString|shows|showsPrec|significand|signum|sin|sinh|snd|sort|span|splitAt|sqrt|subtract|succ|sum|tail|take|takeWhile|tan|tanh|threadToIOResult|toEnum|toInt|toInteger|toLower|toRational|toUpper|truncate|uncurry|undefined|unlines|until|unwords|unzip|unzip3|userError|words|writeFile|zip|zip3|zipWith|zipWith3)\b/,
	// decimal integers and floating point numbers | octal integers | hexadecimal integers
	'number': /\b(?:\d+(?:\.\d+)?(?:e[+-]?\d+)?|0o[0-7]+|0x[0-9a-f]+)\b/i,
	'operator': [
		{
			// infix operator
			pattern: /`(?:[A-Z][\w']*\.)*[_a-z][\w']*`/,
			greedy: true
		},
		{
			// function composition
			pattern: /(\s)\.(?=\s)/,
			lookbehind: true
		},
		// Most of this is needed because of the meaning of a single '.'.
		// If it stands alone freely, it is the function composition.
		// It may also be a separator between a module name and an identifier => no
		// operator. If it comes together with other special characters it is an
		// operator too.
		//
		// This regex means: /[-!#$%*+=?&@|~.:<>^\\\/]+/ without /\./.
		/[-!#$%*+=?&@|~:<>^\\\/][-!#$%*+=?&@|~.:<>^\\\/]*|\.[-!#$%*+=?&@|~.:<>^\\\/]+/,
	],
	// In Haskell, nearly everything is a variable, do not highlight these.
	'hvariable': {
		pattern: /\b(?:[A-Z][\w']*\.)*[_a-z][\w']*/,
		inside: {
			'punctuation': /\./
		}
	},
	'constant': {
		pattern: /\b(?:[A-Z][\w']*\.)*[A-Z][\w']*/,
		inside: {
			'punctuation': /\./
		}
	},
	'punctuation': /[{}[\];(),.:]/
};

Prism.languages.hs = Prism.languages.haskell;

Prism.languages.icon = {
	'comment': /#.*/,
	'string': {
		pattern: /(["'])(?:(?!\1)[^\\\r\n_]|\\.|_(?!\1)(?:\r\n|[\s\S]))*\1/,
		greedy: true
	},
	'number': /\b(?:\d+r[a-z\d]+|\d+(?:\.\d+)?(?:e[+-]?\d+)?)\b|\.\d+\b/i,
	'builtin-keyword': {
		pattern: /&(?:allocated|ascii|clock|collections|cset|current|date|dateline|digits|dump|e|error(?:number|text|value)?|errout|fail|features|file|host|input|lcase|letters|level|line|main|null|output|phi|pi|pos|progname|random|regions|source|storage|subject|time|trace|ucase|version)\b/,
		alias: 'variable'
	},
	'directive': {
		pattern: /\$\w+/,
		alias: 'builtin'
	},
	'keyword': /\b(?:break|by|case|create|default|do|else|end|every|fail|global|if|initial|invocable|link|local|next|not|of|procedure|record|repeat|return|static|suspend|then|to|until|while)\b/,
	'function': /\b(?!\d)\w+(?=\s*[({]|\s*!\s*\[)/,
	'operator': /[+-]:(?!=)|(?:[\/?@^%&]|\+\+?|--?|==?=?|~==?=?|\*\*?|\|\|\|?|<(?:->?|<?=?)|>>?=?)(?::=)?|:(?:=:?)?|[!.\\|~]/,
	'punctuation': /[\[\](){},;]/
};

(function (Prism) {
	Prism.languages.ignore = {
		// https://git-scm.com/docs/gitignore
		'comment': /^#.*/m,
		'entry': {
			pattern: /\S(?:.*(?:(?:\\ )|\S))?/,
			alias: 'string',
			inside: {
				'operator': /^!|\*\*?|\?/,
				'regex': {
					pattern: /(^|[^\\])\[[^\[\]]*\]/,
					lookbehind: true
				},
				'punctuation': /\//
			}
		}
	};

	Prism.languages.gitignore = Prism.languages.ignore;
	Prism.languages.hgignore = Prism.languages.ignore;
	Prism.languages.npmignore = Prism.languages.ignore;

}(Prism));

(function (Prism) {

	var keywords = /\b(?:abstract|assert|boolean|break|byte|case|catch|char|class|const|continue|default|do|double|else|enum|exports|extends|final|finally|float|for|goto|if|implements|import|instanceof|int|interface|long|module|native|new|non-sealed|null|open|opens|package|permits|private|protected|provides|public|record(?!\s*[(){}[\]<>=%~.:,;?+\-*/&|^])|requires|return|sealed|short|static|strictfp|super|switch|synchronized|this|throw|throws|to|transient|transitive|try|uses|var|void|volatile|while|with|yield)\b/;

	// full package (optional) + parent classes (optional)
	var classNamePrefix = /(?:[a-z]\w*\s*\.\s*)*(?:[A-Z]\w*\s*\.\s*)*/.source;

	// based on the java naming conventions
	var className = {
		pattern: RegExp(/(^|[^\w.])/.source + classNamePrefix + /[A-Z](?:[\d_A-Z]*[a-z]\w*)?\b/.source),
		lookbehind: true,
		inside: {
			'namespace': {
				pattern: /^[a-z]\w*(?:\s*\.\s*[a-z]\w*)*(?:\s*\.)?/,
				inside: {
					'punctuation': /\./
				}
			},
			'punctuation': /\./
		}
	};

	Prism.languages.java = Prism.languages.extend('clike', {
		'string': {
			pattern: /(^|[^\\])"(?:\\.|[^"\\\r\n])*"/,
			lookbehind: true,
			greedy: true
		},
		'class-name': [
			className,
			{
				// variables, parameters, and constructor references
				// this to support class names (or generic parameters) which do not contain a lower case letter (also works for methods)
				pattern: RegExp(/(^|[^\w.])/.source + classNamePrefix + /[A-Z]\w*(?=\s+\w+\s*[;,=()]|\s*(?:\[[\s,]*\]\s*)?::\s*new\b)/.source),
				lookbehind: true,
				inside: className.inside
			},
			{
				// class names based on keyword
				// this to support class names (or generic parameters) which do not contain a lower case letter (also works for methods)
				pattern: RegExp(/(\b(?:class|enum|extends|implements|instanceof|interface|new|record|throws)\s+)/.source + classNamePrefix + /[A-Z]\w*\b/.source),
				lookbehind: true,
				inside: className.inside
			}
		],
		'keyword': keywords,
		'function': [
			Prism.languages.clike.function,
			{
				pattern: /(::\s*)[a-z_]\w*/,
				lookbehind: true
			}
		],
		'number': /\b0b[01][01_]*L?\b|\b0x(?:\.[\da-f_p+-]+|[\da-f_]+(?:\.[\da-f_p+-]+)?)\b|(?:\b\d[\d_]*(?:\.[\d_]*)?|\B\.\d[\d_]*)(?:e[+-]?\d[\d_]*)?[dfl]?/i,
		'operator': {
			pattern: /(^|[^.])(?:<<=?|>>>?=?|->|--|\+\+|&&|\|\||::|[?:~]|[-+*/%&|^!=<>]=?)/m,
			lookbehind: true
		},
		'constant': /\b[A-Z][A-Z_\d]+\b/
	});

	Prism.languages.insertBefore('java', 'string', {
		'triple-quoted-string': {
			// http://openjdk.java.net/jeps/355#Description
			pattern: /"""[ \t]*[\r\n](?:(?:"|"")?(?:\\.|[^"\\]))*"""/,
			greedy: true,
			alias: 'string'
		},
		'char': {
			pattern: /'(?:\\.|[^'\\\r\n]){1,6}'/,
			greedy: true
		}
	});

	Prism.languages.insertBefore('java', 'class-name', {
		'annotation': {
			pattern: /(^|[^.])@\w+(?:\s*\.\s*\w+)*/,
			lookbehind: true,
			alias: 'punctuation'
		},
		'generics': {
			pattern: /<(?:[\w\s,.?]|&(?!&)|<(?:[\w\s,.?]|&(?!&)|<(?:[\w\s,.?]|&(?!&)|<(?:[\w\s,.?]|&(?!&))*>)*>)*>)*>/,
			inside: {
				'class-name': className,
				'keyword': keywords,
				'punctuation': /[<>(),.:]/,
				'operator': /[?&|]/
			}
		},
		'import': [
			{
				pattern: RegExp(/(\bimport\s+)/.source + classNamePrefix + /(?:[A-Z]\w*|\*)(?=\s*;)/.source),
				lookbehind: true,
				inside: {
					'namespace': className.inside.namespace,
					'punctuation': /\./,
					'operator': /\*/,
					'class-name': /\w+/
				}
			},
			{
				pattern: RegExp(/(\bimport\s+static\s+)/.source + classNamePrefix + /(?:\w+|\*)(?=\s*;)/.source),
				lookbehind: true,
				alias: 'static',
				inside: {
					'namespace': className.inside.namespace,
					'static': /\b\w+$/,
					'punctuation': /\./,
					'operator': /\*/,
					'class-name': /\w+/
				}
			}
		],
		'namespace': {
			pattern: RegExp(
				/(\b(?:exports|import(?:\s+static)?|module|open|opens|package|provides|requires|to|transitive|uses|with)\s+)(?!<keyword>)[a-z]\w*(?:\.[a-z]\w*)*\.?/
					.source.replace(/<keyword>/g, function () { return keywords.source; })),
			lookbehind: true,
			inside: {
				'punctuation': /\./,
			}
		}
	});
}(Prism));

/**
 * Original by Aaron Harun: http://aahacreative.com/2012/07/31/php-syntax-highlighting-prism/
 * Modified by Miles Johnson: http://milesj.me
 * Rewritten by Tom Pavelec
 *
 * Supports PHP 5.3 - 8.0
 */
(function (Prism) {
	var comment = /\/\*[\s\S]*?\*\/|\/\/.*|#(?!\[).*/;
	var constant = [
		{
			pattern: /\b(?:false|true)\b/i,
			alias: 'boolean'
		},
		{
			pattern: /(::\s*)\b[a-z_]\w*\b(?!\s*\()/i,
			greedy: true,
			lookbehind: true,
		},
		{
			pattern: /(\b(?:case|const)\s+)\b[a-z_]\w*(?=\s*[;=])/i,
			greedy: true,
			lookbehind: true,
		},
		/\b(?:null)\b/i,
		/\b[A-Z_][A-Z0-9_]*\b(?!\s*\()/,
	];
	var number = /\b0b[01]+(?:_[01]+)*\b|\b0o[0-7]+(?:_[0-7]+)*\b|\b0x[\da-f]+(?:_[\da-f]+)*\b|(?:\b\d+(?:_\d+)*\.?(?:\d+(?:_\d+)*)?|\B\.\d+)(?:e[+-]?\d+)?/i;
	var operator = /<?=>|\?\?=?|\.{3}|\??->|[!=]=?=?|::|\*\*=?|--|\+\+|&&|\|\||<<|>>|[?~]|[/^|%*&<>.+-]=?/;
	var punctuation = /[{}\[\](),:;]/;

	Prism.languages.php = {
		'delimiter': {
			pattern: /\?>$|^<\?(?:php(?=\s)|=)?/i,
			alias: 'important'
		},
		'comment': comment,
		'variable': /\$+(?:\w+\b|(?=\{))/,
		'package': {
			pattern: /(namespace\s+|use\s+(?:function\s+)?)(?:\\?\b[a-z_]\w*)+\b(?!\\)/i,
			lookbehind: true,
			inside: {
				'punctuation': /\\/
			}
		},
		'class-name-definition': {
			pattern: /(\b(?:class|enum|interface|trait)\s+)\b[a-z_]\w*(?!\\)\b/i,
			lookbehind: true,
			alias: 'class-name'
		},
		'function-definition': {
			pattern: /(\bfunction\s+)[a-z_]\w*(?=\s*\()/i,
			lookbehind: true,
			alias: 'function'
		},
		'keyword': [
			{
				pattern: /(\(\s*)\b(?:array|bool|boolean|float|int|integer|object|string)\b(?=\s*\))/i,
				alias: 'type-casting',
				greedy: true,
				lookbehind: true
			},
			{
				pattern: /([(,?]\s*)\b(?:array(?!\s*\()|bool|callable|(?:false|null)(?=\s*\|)|float|int|iterable|mixed|object|self|static|string)\b(?=\s*\$)/i,
				alias: 'type-hint',
				greedy: true,
				lookbehind: true
			},
			{
				pattern: /(\)\s*:\s*(?:\?\s*)?)\b(?:array(?!\s*\()|bool|callable|(?:false|null)(?=\s*\|)|float|int|iterable|mixed|never|object|self|static|string|void)\b/i,
				alias: 'return-type',
				greedy: true,
				lookbehind: true
			},
			{
				pattern: /\b(?:array(?!\s*\()|bool|float|int|iterable|mixed|object|string|void)\b/i,
				alias: 'type-declaration',
				greedy: true
			},
			{
				pattern: /(\|\s*)(?:false|null)\b|\b(?:false|null)(?=\s*\|)/i,
				alias: 'type-declaration',
				greedy: true,
				lookbehind: true
			},
			{
				pattern: /\b(?:parent|self|static)(?=\s*::)/i,
				alias: 'static-context',
				greedy: true
			},
			{
				// yield from
				pattern: /(\byield\s+)from\b/i,
				lookbehind: true
			},
			// `class` is always a keyword unlike other keywords
			/\bclass\b/i,
			{
				// https://www.php.net/manual/en/reserved.keywords.php
				//
				// keywords cannot be preceded by "->"
				// the complex lookbehind means `(?<!(?:->|::)\s*)`
				pattern: /((?:^|[^\s>:]|(?:^|[^-])>|(?:^|[^:]):)\s*)\b(?:abstract|and|array|as|break|callable|case|catch|clone|const|continue|declare|default|die|do|echo|else|elseif|empty|enddeclare|endfor|endforeach|endif|endswitch|endwhile|enum|eval|exit|extends|final|finally|fn|for|foreach|function|global|goto|if|implements|include|include_once|instanceof|insteadof|interface|isset|list|match|namespace|never|new|or|parent|print|private|protected|public|readonly|require|require_once|return|self|static|switch|throw|trait|try|unset|use|var|while|xor|yield|__halt_compiler)\b/i,
				lookbehind: true
			}
		],
		'argument-name': {
			pattern: /([(,]\s*)\b[a-z_]\w*(?=\s*:(?!:))/i,
			lookbehind: true
		},
		'class-name': [
			{
				pattern: /(\b(?:extends|implements|instanceof|new(?!\s+self|\s+static))\s+|\bcatch\s*\()\b[a-z_]\w*(?!\\)\b/i,
				greedy: true,
				lookbehind: true
			},
			{
				pattern: /(\|\s*)\b[a-z_]\w*(?!\\)\b/i,
				greedy: true,
				lookbehind: true
			},
			{
				pattern: /\b[a-z_]\w*(?!\\)\b(?=\s*\|)/i,
				greedy: true
			},
			{
				pattern: /(\|\s*)(?:\\?\b[a-z_]\w*)+\b/i,
				alias: 'class-name-fully-qualified',
				greedy: true,
				lookbehind: true,
				inside: {
					'punctuation': /\\/
				}
			},
			{
				pattern: /(?:\\?\b[a-z_]\w*)+\b(?=\s*\|)/i,
				alias: 'class-name-fully-qualified',
				greedy: true,
				inside: {
					'punctuation': /\\/
				}
			},
			{
				pattern: /(\b(?:extends|implements|instanceof|new(?!\s+self\b|\s+static\b))\s+|\bcatch\s*\()(?:\\?\b[a-z_]\w*)+\b(?!\\)/i,
				alias: 'class-name-fully-qualified',
				greedy: true,
				lookbehind: true,
				inside: {
					'punctuation': /\\/
				}
			},
			{
				pattern: /\b[a-z_]\w*(?=\s*\$)/i,
				alias: 'type-declaration',
				greedy: true
			},
			{
				pattern: /(?:\\?\b[a-z_]\w*)+(?=\s*\$)/i,
				alias: ['class-name-fully-qualified', 'type-declaration'],
				greedy: true,
				inside: {
					'punctuation': /\\/
				}
			},
			{
				pattern: /\b[a-z_]\w*(?=\s*::)/i,
				alias: 'static-context',
				greedy: true
			},
			{
				pattern: /(?:\\?\b[a-z_]\w*)+(?=\s*::)/i,
				alias: ['class-name-fully-qualified', 'static-context'],
				greedy: true,
				inside: {
					'punctuation': /\\/
				}
			},
			{
				pattern: /([(,?]\s*)[a-z_]\w*(?=\s*\$)/i,
				alias: 'type-hint',
				greedy: true,
				lookbehind: true
			},
			{
				pattern: /([(,?]\s*)(?:\\?\b[a-z_]\w*)+(?=\s*\$)/i,
				alias: ['class-name-fully-qualified', 'type-hint'],
				greedy: true,
				lookbehind: true,
				inside: {
					'punctuation': /\\/
				}
			},
			{
				pattern: /(\)\s*:\s*(?:\?\s*)?)\b[a-z_]\w*(?!\\)\b/i,
				alias: 'return-type',
				greedy: true,
				lookbehind: true
			},
			{
				pattern: /(\)\s*:\s*(?:\?\s*)?)(?:\\?\b[a-z_]\w*)+\b(?!\\)/i,
				alias: ['class-name-fully-qualified', 'return-type'],
				greedy: true,
				lookbehind: true,
				inside: {
					'punctuation': /\\/
				}
			}
		],
		'constant': constant,
		'function': {
			pattern: /(^|[^\\\w])\\?[a-z_](?:[\w\\]*\w)?(?=\s*\()/i,
			lookbehind: true,
			inside: {
				'punctuation': /\\/
			}
		},
		'property': {
			pattern: /(->\s*)\w+/,
			lookbehind: true
		},
		'number': number,
		'operator': operator,
		'punctuation': punctuation
	};

	var string_interpolation = {
		pattern: /\{\$(?:\{(?:\{[^{}]+\}|[^{}]+)\}|[^{}])+\}|(^|[^\\{])\$+(?:\w+(?:\[[^\r\n\[\]]+\]|->\w+)?)/,
		lookbehind: true,
		inside: Prism.languages.php
	};

	var string = [
		{
			pattern: /<<<'([^']+)'[\r\n](?:.*[\r\n])*?\1;/,
			alias: 'nowdoc-string',
			greedy: true,
			inside: {
				'delimiter': {
					pattern: /^<<<'[^']+'|[a-z_]\w*;$/i,
					alias: 'symbol',
					inside: {
						'punctuation': /^<<<'?|[';]$/
					}
				}
			}
		},
		{
			pattern: /<<<(?:"([^"]+)"[\r\n](?:.*[\r\n])*?\1;|([a-z_]\w*)[\r\n](?:.*[\r\n])*?\2;)/i,
			alias: 'heredoc-string',
			greedy: true,
			inside: {
				'delimiter': {
					pattern: /^<<<(?:"[^"]+"|[a-z_]\w*)|[a-z_]\w*;$/i,
					alias: 'symbol',
					inside: {
						'punctuation': /^<<<"?|[";]$/
					}
				},
				'interpolation': string_interpolation
			}
		},
		{
			pattern: /`(?:\\[\s\S]|[^\\`])*`/,
			alias: 'backtick-quoted-string',
			greedy: true
		},
		{
			pattern: /'(?:\\[\s\S]|[^\\'])*'/,
			alias: 'single-quoted-string',
			greedy: true
		},
		{
			pattern: /"(?:\\[\s\S]|[^\\"])*"/,
			alias: 'double-quoted-string',
			greedy: true,
			inside: {
				'interpolation': string_interpolation
			}
		}
	];

	Prism.languages.insertBefore('php', 'variable', {
		'string': string,
		'attribute': {
			pattern: /#\[(?:[^"'\/#]|\/(?![*/])|\/\/.*$|#(?!\[).*$|\/\*(?:[^*]|\*(?!\/))*\*\/|"(?:\\[\s\S]|[^\\"])*"|'(?:\\[\s\S]|[^\\'])*')+\](?=\s*[a-z$#])/im,
			greedy: true,
			inside: {
				'attribute-content': {
					pattern: /^(#\[)[\s\S]+(?=\]$)/,
					lookbehind: true,
					// inside can appear subset of php
					inside: {
						'comment': comment,
						'string': string,
						'attribute-class-name': [
							{
								pattern: /([^:]|^)\b[a-z_]\w*(?!\\)\b/i,
								alias: 'class-name',
								greedy: true,
								lookbehind: true
							},
							{
								pattern: /([^:]|^)(?:\\?\b[a-z_]\w*)+/i,
								alias: [
									'class-name',
									'class-name-fully-qualified'
								],
								greedy: true,
								lookbehind: true,
								inside: {
									'punctuation': /\\/
								}
							}
						],
						'constant': constant,
						'number': number,
						'operator': operator,
						'punctuation': punctuation
					}
				},
				'delimiter': {
					pattern: /^#\[|\]$/,
					alias: 'punctuation'
				}
			}
		},
	});

	Prism.hooks.add('before-tokenize', function (env) {
		if (!/<\?/.test(env.code)) {
			return;
		}

		var phpPattern = /<\?(?:[^"'/#]|\/(?![*/])|("|')(?:\\[\s\S]|(?!\1)[^\\])*\1|(?:\/\/|#(?!\[))(?:[^?\n\r]|\?(?!>))*(?=$|\?>|[\r\n])|#\[|\/\*(?:[^*]|\*(?!\/))*(?:\*\/|$))*?(?:\?>|$)/g;
		Prism.languages['markup-templating'].buildPlaceholders(env, 'php', phpPattern);
	});

	Prism.hooks.add('after-tokenize', function (env) {
		Prism.languages['markup-templating'].tokenizePlaceholders(env, 'php');
	});

}(Prism));

(function (Prism) {

	var javaDocLike = Prism.languages.javadoclike = {
		'parameter': {
			pattern: /(^[\t ]*(?:\/{3}|\*|\/\*\*)\s*@(?:arg|arguments|param)\s+)\w+/m,
			lookbehind: true
		},
		'keyword': {
			// keywords are the first word in a line preceded be an `@` or surrounded by curly braces.
			// @word, {@word}
			pattern: /(^[\t ]*(?:\/{3}|\*|\/\*\*)\s*|\{)@[a-z][a-zA-Z-]+\b/m,
			lookbehind: true
		},
		'punctuation': /[{}]/
	};


	/**
	 * Adds doc comment support to the given language and calls a given callback on each doc comment pattern.
	 *
	 * @param {string} lang the language add doc comment support to.
	 * @param {(pattern: {inside: {rest: undefined}}) => void} callback the function called with each doc comment pattern as argument.
	 */
	function docCommentSupport(lang, callback) {
		var tokenName = 'doc-comment';

		var grammar = Prism.languages[lang];
		if (!grammar) {
			return;
		}
		var token = grammar[tokenName];

		if (!token) {
			// add doc comment: /** */
			var definition = {};
			definition[tokenName] = {
				pattern: /(^|[^\\])\/\*\*[^/][\s\S]*?(?:\*\/|$)/,
				lookbehind: true,
				alias: 'comment'
			};

			grammar = Prism.languages.insertBefore(lang, 'comment', definition);
			token = grammar[tokenName];
		}

		if (token instanceof RegExp) { // convert regex to object
			token = grammar[tokenName] = { pattern: token };
		}

		if (Array.isArray(token)) {
			for (var i = 0, l = token.length; i < l; i++) {
				if (token[i] instanceof RegExp) {
					token[i] = { pattern: token[i] };
				}
				callback(token[i]);
			}
		} else {
			callback(token);
		}
	}

	/**
	 * Adds doc-comment support to the given languages for the given documentation language.
	 *
	 * @param {string[]|string} languages
	 * @param {Object} docLanguage
	 */
	function addSupport(languages, docLanguage) {
		if (typeof languages === 'string') {
			languages = [languages];
		}

		languages.forEach(function (lang) {
			docCommentSupport(lang, function (pattern) {
				if (!pattern.inside) {
					pattern.inside = {};
				}
				pattern.inside.rest = docLanguage;
			});
		});
	}

	Object.defineProperty(javaDocLike, 'addSupport', { value: addSupport });

	javaDocLike.addSupport(['java', 'javascript', 'php'], javaDocLike);

}(Prism));

(function (Prism) {

	var codeLinePattern = /(^(?:[\t ]*(?:\*\s*)*))[^*\s].*$/m;

	var memberReference = /#\s*\w+(?:\s*\([^()]*\))?/.source;
	var reference = /(?:\b[a-zA-Z]\w+\s*\.\s*)*\b[A-Z]\w*(?:\s*<mem>)?|<mem>/.source.replace(/<mem>/g, function () { return memberReference; });

	Prism.languages.javadoc = Prism.languages.extend('javadoclike', {});
	Prism.languages.insertBefore('javadoc', 'keyword', {
		'reference': {
			pattern: RegExp(/(@(?:exception|link|linkplain|see|throws|value)\s+(?:\*\s*)?)/.source + '(?:' + reference + ')'),
			lookbehind: true,
			inside: {
				'function': {
					pattern: /(#\s*)\w+(?=\s*\()/,
					lookbehind: true
				},
				'field': {
					pattern: /(#\s*)\w+/,
					lookbehind: true
				},
				'namespace': {
					pattern: /\b(?:[a-z]\w*\s*\.\s*)+/,
					inside: {
						'punctuation': /\./
					}
				},
				'class-name': /\b[A-Z]\w*/,
				'keyword': Prism.languages.java.keyword,
				'punctuation': /[#()[\],.]/
			}
		},
		'class-name': {
			// @param <T> the first generic type parameter
			pattern: /(@param\s+)<[A-Z]\w*>/,
			lookbehind: true,
			inside: {
				'punctuation': /[.<>]/
			}
		},
		'code-section': [
			{
				pattern: /(\{@code\s+(?!\s))(?:[^\s{}]|\s+(?![\s}])|\{(?:[^{}]|\{(?:[^{}]|\{(?:[^{}]|\{[^{}]*\})*\})*\})*\})+(?=\s*\})/,
				lookbehind: true,
				inside: {
					'code': {
						// there can't be any HTML inside of {@code} tags
						pattern: codeLinePattern,
						lookbehind: true,
						inside: Prism.languages.java,
						alias: 'language-java'
					}
				}
			},
			{
				pattern: /(<(code|pre|tt)>(?!<code>)\s*)\S(?:\S|\s+\S)*?(?=\s*<\/\2>)/,
				lookbehind: true,
				inside: {
					'line': {
						pattern: codeLinePattern,
						lookbehind: true,
						inside: {
							// highlight HTML tags and entities
							'tag': Prism.languages.markup.tag,
							'entity': Prism.languages.markup.entity,
							'code': {
								// everything else is Java code
								pattern: /.+/,
								inside: Prism.languages.java,
								alias: 'language-java'
							}
						}
					}
				}
			}
		],
		'tag': Prism.languages.markup.tag,
		'entity': Prism.languages.markup.entity,
	});

	Prism.languages.javadoclike.addSupport('java', Prism.languages.javadoc);
}(Prism));

// Specification:
// https://docs.oracle.com/en/java/javase/13/docs/api/java.base/java/lang/Throwable.html#printStackTrace()

Prism.languages.javastacktrace = {

	// java.sql.SQLException: Violation of unique constraint MY_ENTITY_UK_1: duplicate value(s) for column(s) MY_COLUMN in statement [...]
	// Caused by: java.sql.SQLException: Violation of unique constraint MY_ENTITY_UK_1: duplicate value(s) for column(s) MY_COLUMN in statement [...]
	// Caused by: com.example.myproject.MyProjectServletException
	// Caused by: MidLevelException: LowLevelException
	// Suppressed: Resource$CloseFailException: Resource ID = 0
	'summary': {
		pattern: /^([\t ]*)(?:(?:Caused by:|Suppressed:|Exception in thread "[^"]*")[\t ]+)?[\w$.]+(?::.*)?$/m,
		lookbehind: true,
		inside: {
			'keyword': {
				pattern: /^([\t ]*)(?:(?:Caused by|Suppressed)(?=:)|Exception in thread)/m,
				lookbehind: true
			},

			// the current thread if the summary starts with 'Exception in thread'
			'string': {
				pattern: /^(\s*)"[^"]*"/,
				lookbehind: true
			},
			'exceptions': {
				pattern: /^(:?\s*)[\w$.]+(?=:|$)/,
				lookbehind: true,
				inside: {
					'class-name': /[\w$]+$/,
					'namespace': /\b[a-z]\w*\b/,
					'punctuation': /\./
				}
			},
			'message': {
				pattern: /(:\s*)\S.*/,
				lookbehind: true,
				alias: 'string'
			},
			'punctuation': /:/
		}
	},

	// at org.mortbay.jetty.servlet.ServletHandler$CachedChain.doFilter(ServletHandler.java:1166)
	// at org.hsqldb.jdbc.Util.throwError(Unknown Source) here could be some notes
	// at java.base/java.lang.Class.forName0(Native Method)
	// at Util.<init>(Unknown Source)
	// at com.foo.loader/foo@9.0/com.foo.Main.run(Main.java:101)
	// at com.foo.loader//com.foo.bar.App.run(App.java:12)
	// at acme@2.1/org.acme.Lib.test(Lib.java:80)
	// at MyClass.mash(MyClass.java:9)
	//
	// More information:
	// https://docs.oracle.com/en/java/javase/13/docs/api/java.base/java/lang/StackTraceElement.html#toString()
	//
	// A valid Java module name is defined as:
	//   "A module name consists of one or more Java identifiers (§3.8) separated by "." tokens."
	// https://docs.oracle.com/javase/specs/jls/se9/html/jls-6.html#jls-ModuleName
	//
	// A Java module version is defined by this class:
	// https://docs.oracle.com/javase/9/docs/api/java/lang/module/ModuleDescriptor.Version.html
	// This is the implementation of the `parse` method in JDK13:
	// https://github.com/matcdac/jdk/blob/2305df71d1b7710266ae0956d73927a225132c0f/src/java.base/share/classes/java/lang/module/ModuleDescriptor.java#L1108
	// However, to keep this simple, a version will be matched by the pattern /@[\w$.+-]*/.
	'stack-frame': {
		pattern: /^([\t ]*)at (?:[\w$./]|@[\w$.+-]*\/)+(?:<init>)?\([^()]*\)/m,
		lookbehind: true,
		inside: {
			'keyword': {
				pattern: /^(\s*)at(?= )/,
				lookbehind: true
			},
			'source': [
				// (Main.java:15)
				// (Main.scala:15)
				{
					pattern: /(\()\w+\.\w+:\d+(?=\))/,
					lookbehind: true,
					inside: {
						'file': /^\w+\.\w+/,
						'punctuation': /:/,
						'line-number': {
							pattern: /\b\d+\b/,
							alias: 'number'
						}
					}
				},
				// (Unknown Source)
				// (Native Method)
				// (...something...)
				{
					pattern: /(\()[^()]*(?=\))/,
					lookbehind: true,
					inside: {
						'keyword': /^(?:Native Method|Unknown Source)$/
					}
				}
			],
			'class-name': /[\w$]+(?=\.(?:<init>|[\w$]+)\()/,
			'function': /(?:<init>|[\w$]+)(?=\()/,
			'class-loader': {
				pattern: /(\s)[a-z]\w*(?:\.[a-z]\w*)*(?=\/[\w@$.]*\/)/,
				lookbehind: true,
				alias: 'namespace',
				inside: {
					'punctuation': /\./
				}
			},
			'module': {
				pattern: /([\s/])[a-z]\w*(?:\.[a-z]\w*)*(?:@[\w$.+-]*)?(?=\/)/,
				lookbehind: true,
				inside: {
					'version': {
						pattern: /(@)[\s\S]+/,
						lookbehind: true,
						alias: 'number'
					},
					'punctuation': /[@.]/
				}
			},
			'namespace': {
				pattern: /(?:\b[a-z]\w*\.)+/,
				inside: {
					'punctuation': /\./
				}
			},
			'punctuation': /[()/.]/
		}
	},

	// ... 32 more
	// ... 32 common frames omitted
	'more': {
		pattern: /^([\t ]*)\.{3} \d+ [a-z]+(?: [a-z]+)*/m,
		lookbehind: true,
		inside: {
			'punctuation': /\.{3}/,
			'number': /\d+/,
			'keyword': /\b[a-z]+(?: [a-z]+)*\b/
		}
	}

};

(function (Prism) {

	var interpolation = /\\\((?:[^()]|\([^()]*\))*\)/.source;
	var string = RegExp(/(^|[^\\])"(?:[^"\r\n\\]|\\[^\r\n(]|__)*"/.source.replace(/__/g, function () { return interpolation; }));
	var stringInterpolation = {
		'interpolation': {
			pattern: RegExp(/((?:^|[^\\])(?:\\{2})*)/.source + interpolation),
			lookbehind: true,
			inside: {
				'content': {
					pattern: /^(\\\()[\s\S]+(?=\)$)/,
					lookbehind: true,
					inside: null // see below
				},
				'punctuation': /^\\\(|\)$/
			}
		}
	};

	var jq = Prism.languages.jq = {
		'comment': /#.*/,
		'property': {
			pattern: RegExp(string.source + /(?=\s*:(?!:))/.source),
			lookbehind: true,
			greedy: true,
			inside: stringInterpolation
		},
		'string': {
			pattern: string,
			lookbehind: true,
			greedy: true,
			inside: stringInterpolation
		},

		'function': {
			pattern: /(\bdef\s+)[a-z_]\w+/i,
			lookbehind: true
		},

		'variable': /\B\$\w+/,
		'property-literal': {
			pattern: /\b[a-z_]\w*(?=\s*:(?!:))/i,
			alias: 'property'
		},
		'keyword': /\b(?:as|break|catch|def|elif|else|end|foreach|if|import|include|label|module|modulemeta|null|reduce|then|try|while)\b/,
		'boolean': /\b(?:false|true)\b/,
		'number': /(?:\b\d+\.|\B\.)?\b\d+(?:[eE][+-]?\d+)?\b/,

		'operator': [
			{
				pattern: /\|=?/,
				alias: 'pipe'
			},
			/\.\.|[!=<>]?=|\?\/\/|\/\/=?|[-+*/%]=?|[<>?]|\b(?:and|not|or)\b/
		],
		'c-style-function': {
			pattern: /\b[a-z_]\w*(?=\s*\()/i,
			alias: 'function'
		},
		'punctuation': /::|[()\[\]{},:;]|\.(?=\s*[\[\w$])/,
		'dot': {
			pattern: /\./,
			alias: 'important'
		}
	};

	stringInterpolation.interpolation.inside.content.inside = jq;

}(Prism));

(function (Prism) {

	Prism.languages.typescript = Prism.languages.extend('javascript', {
		'class-name': {
			pattern: /(\b(?:class|extends|implements|instanceof|interface|new|type)\s+)(?!keyof\b)(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*(?:\s*<(?:[^<>]|<(?:[^<>]|<[^<>]*>)*>)*>)?/,
			lookbehind: true,
			greedy: true,
			inside: null // see below
		},
		'builtin': /\b(?:Array|Function|Promise|any|boolean|console|never|number|string|symbol|unknown)\b/,
	});

	// The keywords TypeScript adds to JavaScript
	Prism.languages.typescript.keyword.push(
		/\b(?:abstract|declare|is|keyof|readonly|require)\b/,
		// keywords that have to be followed by an identifier
		/\b(?:asserts|infer|interface|module|namespace|type)\b(?=\s*(?:[{_$a-zA-Z\xA0-\uFFFF]|$))/,
		// This is for `import type *, {}`
		/\btype\b(?=\s*(?:[\{*]|$))/
	);

	// doesn't work with TS because TS is too complex
	delete Prism.languages.typescript['parameter'];
	delete Prism.languages.typescript['literal-property'];

	// a version of typescript specifically for highlighting types
	var typeInside = Prism.languages.extend('typescript', {});
	delete typeInside['class-name'];

	Prism.languages.typescript['class-name'].inside = typeInside;

	Prism.languages.insertBefore('typescript', 'function', {
		'decorator': {
			pattern: /@[$\w\xA0-\uFFFF]+/,
			inside: {
				'at': {
					pattern: /^@/,
					alias: 'operator'
				},
				'function': /^[\s\S]+/
			}
		},
		'generic-function': {
			// e.g. foo<T extends "bar" | "baz">( ...
			pattern: /#?(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*\s*<(?:[^<>]|<(?:[^<>]|<[^<>]*>)*>)*>(?=\s*\()/,
			greedy: true,
			inside: {
				'function': /^#?(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*/,
				'generic': {
					pattern: /<[\s\S]+/, // everything after the first <
					alias: 'class-name',
					inside: typeInside
				}
			}
		}
	});

	Prism.languages.ts = Prism.languages.typescript;

}(Prism));

(function (Prism) {

	var javascript = Prism.languages.javascript;

	var type = /\{(?:[^{}]|\{(?:[^{}]|\{[^{}]*\})*\})+\}/.source;
	var parameterPrefix = '(@(?:arg|argument|param|property)\\s+(?:' + type + '\\s+)?)';

	Prism.languages.jsdoc = Prism.languages.extend('javadoclike', {
		'parameter': {
			// @param {string} foo - foo bar
			pattern: RegExp(parameterPrefix + /(?:(?!\s)[$\w\xA0-\uFFFF.])+(?=\s|$)/.source),
			lookbehind: true,
			inside: {
				'punctuation': /\./
			}
		}
	});

	Prism.languages.insertBefore('jsdoc', 'keyword', {
		'optional-parameter': {
			// @param {string} [baz.foo="bar"] foo bar
			pattern: RegExp(parameterPrefix + /\[(?:(?!\s)[$\w\xA0-\uFFFF.])+(?:=[^[\]]+)?\](?=\s|$)/.source),
			lookbehind: true,
			inside: {
				'parameter': {
					pattern: /(^\[)[$\w\xA0-\uFFFF\.]+/,
					lookbehind: true,
					inside: {
						'punctuation': /\./
					}
				},
				'code': {
					pattern: /(=)[\s\S]*(?=\]$)/,
					lookbehind: true,
					inside: javascript,
					alias: 'language-javascript'
				},
				'punctuation': /[=[\]]/
			}
		},
		'class-name': [
			{
				pattern: RegExp(/(@(?:augments|class|extends|interface|memberof!?|template|this|typedef)\s+(?:<TYPE>\s+)?)[A-Z]\w*(?:\.[A-Z]\w*)*/.source.replace(/<TYPE>/g, function () { return type; })),
				lookbehind: true,
				inside: {
					'punctuation': /\./
				}
			},
			{
				pattern: RegExp('(@[a-z]+\\s+)' + type),
				lookbehind: true,
				inside: {
					'string': javascript.string,
					'number': javascript.number,
					'boolean': javascript.boolean,
					'keyword': Prism.languages.typescript.keyword,
					'operator': /=>|\.\.\.|[&|?:*]/,
					'punctuation': /[.,;=<>{}()[\]]/
				}
			}
		],
		'example': {
			pattern: /(@example\s+(?!\s))(?:[^@\s]|\s+(?!\s))+?(?=\s*(?:\*\s*)?(?:@\w|\*\/))/,
			lookbehind: true,
			inside: {
				'code': {
					pattern: /^([\t ]*(?:\*\s*)?)\S.*$/m,
					lookbehind: true,
					inside: javascript,
					alias: 'language-javascript'
				}
			}
		}
	});

	Prism.languages.javadoclike.addSupport('javascript', Prism.languages.jsdoc);

}(Prism));

(function (Prism) {

	Prism.languages.insertBefore('javascript', 'function-variable', {
		'method-variable': {
			pattern: RegExp('(\\.\\s*)' + Prism.languages.javascript['function-variable'].pattern.source),
			lookbehind: true,
			alias: ['function-variable', 'method', 'function', 'property-access']
		}
	});

	Prism.languages.insertBefore('javascript', 'function', {
		'method': {
			pattern: RegExp('(\\.\\s*)' + Prism.languages.javascript['function'].source),
			lookbehind: true,
			alias: ['function', 'property-access']
		}
	});

	Prism.languages.insertBefore('javascript', 'constant', {
		'known-class-name': [
			{
				// standard built-ins
				// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects
				pattern: /\b(?:(?:Float(?:32|64)|(?:Int|Uint)(?:8|16|32)|Uint8Clamped)?Array|ArrayBuffer|BigInt|Boolean|DataView|Date|Error|Function|Intl|JSON|(?:Weak)?(?:Map|Set)|Math|Number|Object|Promise|Proxy|Reflect|RegExp|String|Symbol|WebAssembly)\b/,
				alias: 'class-name'
			},
			{
				// errors
				pattern: /\b(?:[A-Z]\w*)Error\b/,
				alias: 'class-name'
			}
		]
	});

	/**
	 * Replaces the `<ID>` placeholder in the given pattern with a pattern for general JS identifiers.
	 *
	 * @param {string} source
	 * @param {string} [flags]
	 * @returns {RegExp}
	 */
	function withId(source, flags) {
		return RegExp(
			source.replace(/<ID>/g, function () { return /(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*/.source; }),
			flags);
	}
	Prism.languages.insertBefore('javascript', 'keyword', {
		'imports': {
			// https://tc39.es/ecma262/#sec-imports
			pattern: withId(/(\bimport\b\s*)(?:<ID>(?:\s*,\s*(?:\*\s*as\s+<ID>|\{[^{}]*\}))?|\*\s*as\s+<ID>|\{[^{}]*\})(?=\s*\bfrom\b)/.source),
			lookbehind: true,
			inside: Prism.languages.javascript
		},
		'exports': {
			// https://tc39.es/ecma262/#sec-exports
			pattern: withId(/(\bexport\b\s*)(?:\*(?:\s*as\s+<ID>)?(?=\s*\bfrom\b)|\{[^{}]*\})/.source),
			lookbehind: true,
			inside: Prism.languages.javascript
		}
	});

	Prism.languages.javascript['keyword'].unshift(
		{
			pattern: /\b(?:as|default|export|from|import)\b/,
			alias: 'module'
		},
		{
			pattern: /\b(?:await|break|catch|continue|do|else|finally|for|if|return|switch|throw|try|while|yield)\b/,
			alias: 'control-flow'
		},
		{
			pattern: /\bnull\b/,
			alias: ['null', 'nil']
		},
		{
			pattern: /\bundefined\b/,
			alias: 'nil'
		}
	);

	Prism.languages.insertBefore('javascript', 'operator', {
		'spread': {
			pattern: /\.{3}/,
			alias: 'operator'
		},
		'arrow': {
			pattern: /=>/,
			alias: 'operator'
		}
	});

	Prism.languages.insertBefore('javascript', 'punctuation', {
		'property-access': {
			pattern: withId(/(\.\s*)#?<ID>/.source),
			lookbehind: true
		},
		'maybe-class-name': {
			pattern: /(^|[^$\w\xA0-\uFFFF])[A-Z][$\w\xA0-\uFFFF]+/,
			lookbehind: true
		},
		'dom': {
			// this contains only a few commonly used DOM variables
			pattern: /\b(?:document|(?:local|session)Storage|location|navigator|performance|window)\b/,
			alias: 'variable'
		},
		'console': {
			pattern: /\bconsole(?=\s*\.)/,
			alias: 'class-name'
		}
	});


	// add 'maybe-class-name' to tokens which might be a class name
	var maybeClassNameTokens = ['function', 'function-variable', 'method', 'method-variable', 'property-access'];

	for (var i = 0; i < maybeClassNameTokens.length; i++) {
		var token = maybeClassNameTokens[i];
		var value = Prism.languages.javascript[token];

		// convert regex to object
		if (Prism.util.type(value) === 'RegExp') {
			value = Prism.languages.javascript[token] = {
				pattern: value
			};
		}

		// keep in mind that we don't support arrays

		var inside = value.inside || {};
		value.inside = inside;

		inside['maybe-class-name'] = /^[A-Z][\s\S]*/;
	}

}(Prism));

// https://www.json.org/json-en.html
Prism.languages.json = {
	'property': {
		pattern: /(^|[^\\])"(?:\\.|[^\\"\r\n])*"(?=\s*:)/,
		lookbehind: true,
		greedy: true
	},
	'string': {
		pattern: /(^|[^\\])"(?:\\.|[^\\"\r\n])*"(?!\s*:)/,
		lookbehind: true,
		greedy: true
	},
	'comment': {
		pattern: /\/\/.*|\/\*[\s\S]*?(?:\*\/|$)/,
		greedy: true
	},
	'number': /-?\b\d+(?:\.\d+)?(?:e[+-]?\d+)?\b/i,
	'punctuation': /[{}[\],]/,
	'operator': /:/,
	'boolean': /\b(?:false|true)\b/,
	'null': {
		pattern: /\bnull\b/,
		alias: 'keyword'
	}
};

Prism.languages.webmanifest = Prism.languages.json;

(function (Prism) {

	var string = /("|')(?:\\(?:\r\n?|\n|.)|(?!\1)[^\\\r\n])*\1/;

	Prism.languages.json5 = Prism.languages.extend('json', {
		'property': [
			{
				pattern: RegExp(string.source + '(?=\\s*:)'),
				greedy: true
			},
			{
				pattern: /(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*(?=\s*:)/,
				alias: 'unquoted'
			}
		],
		'string': {
			pattern: string,
			greedy: true
		},
		'number': /[+-]?\b(?:NaN|Infinity|0x[a-fA-F\d]+)\b|[+-]?(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:[eE][+-]?\d+\b)?/
	});

}(Prism));

Prism.languages.jsonp = Prism.languages.extend('json', {
	'punctuation': /[{}[\]();,.]/
});

Prism.languages.insertBefore('jsonp', 'punctuation', {
	'function': /(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*(?=\s*\()/
});

Prism.languages.jsstacktrace = {
	'error-message': {
		pattern: /^\S.*/m,
		alias: 'string'
	},

	'stack-frame': {
		pattern: /(^[ \t]+)at[ \t].*/m,
		lookbehind: true,
		inside: {
			'not-my-code': {
				pattern: /^at[ \t]+(?!\s)(?:node\.js|<unknown>|.*(?:node_modules|\(<anonymous>\)|\(<unknown>|<anonymous>$|\(internal\/|\(node\.js)).*/m,
				alias: 'comment'
			},

			'filename': {
				pattern: /(\bat\s+(?!\s)|\()(?:[a-zA-Z]:)?[^():]+(?=:)/,
				lookbehind: true,
				alias: 'url'
			},

			'function': {
				pattern: /(\bat\s+(?:new\s+)?)(?!\s)[_$a-zA-Z\xA0-\uFFFF<][.$\w\xA0-\uFFFF<>]*/,
				lookbehind: true,
				inside: {
					'punctuation': /\./
				}
			},

			'punctuation': /[()]/,

			'keyword': /\b(?:at|new)\b/,

			'alias': {
				pattern: /\[(?:as\s+)?(?!\s)[_$a-zA-Z\xA0-\uFFFF][$\w\xA0-\uFFFF]*\]/,
				alias: 'variable'
			},

			'line-number': {
				pattern: /:\d+(?::\d+)?\b/,
				alias: 'number',
				inside: {
					'punctuation': /:/
				}
			},

		}
	}
};

(function (Prism) {

	var templateString = Prism.languages.javascript['template-string'];

	// see the pattern in prism-javascript.js
	var templateLiteralPattern = templateString.pattern.source;
	var interpolationObject = templateString.inside['interpolation'];
	var interpolationPunctuationObject = interpolationObject.inside['interpolation-punctuation'];
	var interpolationPattern = interpolationObject.pattern.source;


	/**
	 * Creates a new pattern to match a template string with a special tag.
	 *
	 * This will return `undefined` if there is no grammar with the given language id.
	 *
	 * @param {string} language The language id of the embedded language. E.g. `markdown`.
	 * @param {string} tag The regex pattern to match the tag.
	 * @returns {object | undefined}
	 * @example
	 * createTemplate('css', /\bcss/.source);
	 */
	function createTemplate(language, tag) {
		if (!Prism.languages[language]) {
			return undefined;
		}

		return {
			pattern: RegExp('((?:' + tag + ')\\s*)' + templateLiteralPattern),
			lookbehind: true,
			greedy: true,
			inside: {
				'template-punctuation': {
					pattern: /^`|`$/,
					alias: 'string'
				},
				'embedded-code': {
					pattern: /[\s\S]+/,
					alias: language
				}
			}
		};
	}


	Prism.languages.javascript['template-string'] = [
		// styled-jsx:
		//   css`a { color: #25F; }`
		// styled-components:
		//   styled.h1`color: red;`
		createTemplate('css', /\b(?:styled(?:\([^)]*\))?(?:\s*\.\s*\w+(?:\([^)]*\))*)*|css(?:\s*\.\s*(?:global|resolve))?|createGlobalStyle|keyframes)/.source),

		// html`<p></p>`
		// div.innerHTML = `<p></p>`
		createTemplate('html', /\bhtml|\.\s*(?:inner|outer)HTML\s*\+?=/.source),

		// svg`<path fill="#fff" d="M55.37 ..."/>`
		createTemplate('svg', /\bsvg/.source),

		// md`# h1`, markdown`## h2`
		createTemplate('markdown', /\b(?:markdown|md)/.source),

		// gql`...`, graphql`...`, graphql.experimental`...`
		createTemplate('graphql', /\b(?:gql|graphql(?:\s*\.\s*experimental)?)/.source),

		// sql`...`
		createTemplate('sql', /\bsql/.source),

		// vanilla template string
		templateString
	].filter(Boolean);


	/**
	 * Returns a specific placeholder literal for the given language.
	 *
	 * @param {number} counter
	 * @param {string} language
	 * @returns {string}
	 */
	function getPlaceholder(counter, language) {
		return '___' + language.toUpperCase() + '_' + counter + '___';
	}

	/**
	 * Returns the tokens of `Prism.tokenize` but also runs the `before-tokenize` and `after-tokenize` hooks.
	 *
	 * @param {string} code
	 * @param {any} grammar
	 * @param {string} language
	 * @returns {(string|Token)[]}
	 */
	function tokenizeWithHooks(code, grammar, language) {
		var env = {
			code: code,
			grammar: grammar,
			language: language
		};
		Prism.hooks.run('before-tokenize', env);
		env.tokens = Prism.tokenize(env.code, env.grammar);
		Prism.hooks.run('after-tokenize', env);
		return env.tokens;
	}

	/**
	 * Returns the token of the given JavaScript interpolation expression.
	 *
	 * @param {string} expression The code of the expression. E.g. `"${42}"`
	 * @returns {Token}
	 */
	function tokenizeInterpolationExpression(expression) {
		var tempGrammar = {};
		tempGrammar['interpolation-punctuation'] = interpolationPunctuationObject;

		/** @type {Array} */
		var tokens = Prism.tokenize(expression, tempGrammar);
		if (tokens.length === 3) {
			/**
			 * The token array will look like this
			 * [
			 *     ["interpolation-punctuation", "${"]
			 *     "..." // JavaScript expression of the interpolation
			 *     ["interpolation-punctuation", "}"]
			 * ]
			 */

			var args = [1, 1];
			args.push.apply(args, tokenizeWithHooks(tokens[1], Prism.languages.javascript, 'javascript'));

			tokens.splice.apply(tokens, args);
		}

		return new Prism.Token('interpolation', tokens, interpolationObject.alias, expression);
	}

	/**
	 * Tokenizes the given code with support for JavaScript interpolation expressions mixed in.
	 *
	 * This function has 3 phases:
	 *
	 * 1. Replace all JavaScript interpolation expression with a placeholder.
	 *    The placeholder will have the syntax of a identify of the target language.
	 * 2. Tokenize the code with placeholders.
	 * 3. Tokenize the interpolation expressions and re-insert them into the tokenize code.
	 *    The insertion only works if a placeholder hasn't been "ripped apart" meaning that the placeholder has been
	 *    tokenized as two tokens by the grammar of the embedded language.
	 *
	 * @param {string} code
	 * @param {object} grammar
	 * @param {string} language
	 * @returns {Token}
	 */
	function tokenizeEmbedded(code, grammar, language) {
		// 1. First filter out all interpolations

		// because they might be escaped, we need a lookbehind, so we use Prism
		/** @type {(Token|string)[]} */
		var _tokens = Prism.tokenize(code, {
			'interpolation': {
				pattern: RegExp(interpolationPattern),
				lookbehind: true
			}
		});

		// replace all interpolations with a placeholder which is not in the code already
		var placeholderCounter = 0;
		/** @type {Object<string, string>} */
		var placeholderMap = {};
		var embeddedCode = _tokens.map(function (token) {
			if (typeof token === 'string') {
				return token;
			} else {
				var interpolationExpression = token.content;

				var placeholder;
				while (code.indexOf(placeholder = getPlaceholder(placeholderCounter++, language)) !== -1) { /* noop */ }
				placeholderMap[placeholder] = interpolationExpression;
				return placeholder;
			}
		}).join('');


		// 2. Tokenize the embedded code

		var embeddedTokens = tokenizeWithHooks(embeddedCode, grammar, language);


		// 3. Re-insert the interpolation

		var placeholders = Object.keys(placeholderMap);
		placeholderCounter = 0;

		/**
		 *
		 * @param {(Token|string)[]} tokens
		 * @returns {void}
		 */
		function walkTokens(tokens) {
			for (var i = 0; i < tokens.length; i++) {
				if (placeholderCounter >= placeholders.length) {
					return;
				}

				var token = tokens[i];

				if (typeof token === 'string' || typeof token.content === 'string') {
					var placeholder = placeholders[placeholderCounter];
					var s = typeof token === 'string' ? token : /** @type {string} */ (token.content);

					var index = s.indexOf(placeholder);
					if (index !== -1) {
						++placeholderCounter;

						var before = s.substring(0, index);
						var middle = tokenizeInterpolationExpression(placeholderMap[placeholder]);
						var after = s.substring(index + placeholder.length);

						var replacement = [];
						if (before) {
							replacement.push(before);
						}
						replacement.push(middle);
						if (after) {
							var afterTokens = [after];
							walkTokens(afterTokens);
							replacement.push.apply(replacement, afterTokens);
						}

						if (typeof token === 'string') {
							tokens.splice.apply(tokens, [i, 1].concat(replacement));
							i += replacement.length - 1;
						} else {
							token.content = replacement;
						}
					}
				} else {
					var content = token.content;
					if (Array.isArray(content)) {
						walkTokens(content);
					} else {
						walkTokens([content]);
					}
				}
			}
		}
		walkTokens(embeddedTokens);

		return new Prism.Token(language, embeddedTokens, 'language-' + language, code);
	}

	/**
	 * The languages for which JS templating will handle tagged template literals.
	 *
	 * JS templating isn't active for only JavaScript but also related languages like TypeScript, JSX, and TSX.
	 */
	var supportedLanguages = {
		'javascript': true,
		'js': true,
		'typescript': true,
		'ts': true,
		'jsx': true,
		'tsx': true,
	};
	Prism.hooks.add('after-tokenize', function (env) {
		if (!(env.language in supportedLanguages)) {
			return;
		}

		/**
		 * Finds and tokenizes all template strings with an embedded languages.
		 *
		 * @param {(Token | string)[]} tokens
		 * @returns {void}
		 */
		function findTemplateStrings(tokens) {
			for (var i = 0, l = tokens.length; i < l; i++) {
				var token = tokens[i];

				if (typeof token === 'string') {
					continue;
				}

				var content = token.content;
				if (!Array.isArray(content)) {
					if (typeof content !== 'string') {
						findTemplateStrings([content]);
					}
					continue;
				}

				if (token.type === 'template-string') {
					/**
					 * A JavaScript template-string token will look like this:
					 *
					 * ["template-string", [
					 *     ["template-punctuation", "`"],
					 *     (
					 *         An array of "string" and "interpolation" tokens. This is the simple string case.
					 *         or
					 *         ["embedded-code", "..."] This is the token containing the embedded code.
					 *                                  It also has an alias which is the language of the embedded code.
					 *     ),
					 *     ["template-punctuation", "`"]
					 * ]]
					 */

					var embedded = content[1];
					if (content.length === 3 && typeof embedded !== 'string' && embedded.type === 'embedded-code') {
						// get string content
						var code = stringContent(embedded);

						var alias = embedded.alias;
						var language = Array.isArray(alias) ? alias[0] : alias;

						var grammar = Prism.languages[language];
						if (!grammar) {
							// the embedded language isn't registered.
							continue;
						}

						content[1] = tokenizeEmbedded(code, grammar, language);
					}
				} else {
					findTemplateStrings(content);
				}
			}
		}

		findTemplateStrings(env.tokens);
	});


	/**
	 * Returns the string content of a token or token stream.
	 *
	 * @param {string | Token | (string | Token)[]} value
	 * @returns {string}
	 */
	function stringContent(value) {
		if (typeof value === 'string') {
			return value;
		} else if (Array.isArray(value)) {
			return value.map(stringContent).join('');
		} else {
			return stringContent(value.content);
		}
	}

}(Prism));

Prism.languages.julia = {
	'comment': {
		// support one level of nested comments
		// https://github.com/JuliaLang/julia/pull/6128
		pattern: /(^|[^\\])(?:#=(?:[^#=]|=(?!#)|#(?!=)|#=(?:[^#=]|=(?!#)|#(?!=))*=#)*=#|#.*)/,
		lookbehind: true
	},
	'regex': {
		// https://docs.julialang.org/en/v1/manual/strings/#Regular-Expressions-1
		pattern: /r"(?:\\.|[^"\\\r\n])*"[imsx]{0,4}/,
		greedy: true
	},
	'string': {
		// https://docs.julialang.org/en/v1/manual/strings/#String-Basics-1
		// https://docs.julialang.org/en/v1/manual/strings/#non-standard-string-literals-1
		// https://docs.julialang.org/en/v1/manual/running-external-programs/#Running-External-Programs-1
		pattern: /"""[\s\S]+?"""|(?:\b\w+)?"(?:\\.|[^"\\\r\n])*"|`(?:[^\\`\r\n]|\\.)*`/,
		greedy: true
	},
	'char': {
		// https://docs.julialang.org/en/v1/manual/strings/#man-characters-1
		pattern: /(^|[^\w'])'(?:\\[^\r\n][^'\r\n]*|[^\\\r\n])'/,
		lookbehind: true,
		greedy: true
	},
	'keyword': /\b(?:abstract|baremodule|begin|bitstype|break|catch|ccall|const|continue|do|else|elseif|end|export|finally|for|function|global|if|immutable|import|importall|in|let|local|macro|module|print|println|quote|return|struct|try|type|typealias|using|while)\b/,
	'boolean': /\b(?:false|true)\b/,
	'number': /(?:\b(?=\d)|\B(?=\.))(?:0[box])?(?:[\da-f]+(?:_[\da-f]+)*(?:\.(?:\d+(?:_\d+)*)?)?|\.\d+(?:_\d+)*)(?:[efp][+-]?\d+(?:_\d+)*)?j?/i,
	// https://docs.julialang.org/en/v1/manual/mathematical-operations/
	// https://docs.julialang.org/en/v1/manual/mathematical-operations/#Operator-Precedence-and-Associativity-1
	'operator': /&&|\|\||[-+*^%÷⊻&$\\]=?|\/[\/=]?|!=?=?|\|[=>]?|<(?:<=?|[=:|])?|>(?:=|>>?=?)?|==?=?|[~≠≤≥'√∛]/,
	'punctuation': /::?|[{}[\]();,.?]/,
	// https://docs.julialang.org/en/v1/base/numbers/#Base.im
	'constant': /\b(?:(?:Inf|NaN)(?:16|32|64)?|im|pi)\b|[πℯ]/
};

(function (Prism) {
	var funcPattern = /\\(?:[^a-z()[\]]|[a-z*]+)/i;
	var insideEqu = {
		'equation-command': {
			pattern: funcPattern,
			alias: 'regex'
		}
	};

	Prism.languages.latex = {
		'comment': /%.*/,
		// the verbatim environment prints whitespace to the document
		'cdata': {
			pattern: /(\\begin\{((?:lstlisting|verbatim)\*?)\})[\s\S]*?(?=\\end\{\2\})/,
			lookbehind: true
		},
		/*
		 * equations can be between $$ $$ or $ $ or \( \) or \[ \]
		 * (all are multiline)
		 */
		'equation': [
			{
				pattern: /\$\$(?:\\[\s\S]|[^\\$])+\$\$|\$(?:\\[\s\S]|[^\\$])+\$|\\\([\s\S]*?\\\)|\\\[[\s\S]*?\\\]/,
				inside: insideEqu,
				alias: 'string'
			},
			{
				pattern: /(\\begin\{((?:align|eqnarray|equation|gather|math|multline)\*?)\})[\s\S]*?(?=\\end\{\2\})/,
				lookbehind: true,
				inside: insideEqu,
				alias: 'string'
			}
		],
		/*
		 * arguments which are keywords or references are highlighted
		 * as keywords
		 */
		'keyword': {
			pattern: /(\\(?:begin|cite|documentclass|end|label|ref|usepackage)(?:\[[^\]]+\])?\{)[^}]+(?=\})/,
			lookbehind: true
		},
		'url': {
			pattern: /(\\url\{)[^}]+(?=\})/,
			lookbehind: true
		},
		/*
		 * section or chapter headlines are highlighted as bold so that
		 * they stand out more
		 */
		'headline': {
			pattern: /(\\(?:chapter|frametitle|paragraph|part|section|subparagraph|subsection|subsubparagraph|subsubsection|subsubsubparagraph)\*?(?:\[[^\]]+\])?\{)[^}]+(?=\})/,
			lookbehind: true,
			alias: 'class-name'
		},
		'function': {
			pattern: funcPattern,
			alias: 'selector'
		},
		'punctuation': /[[\]{}&]/
	};

	Prism.languages.tex = Prism.languages.latex;
	Prism.languages.context = Prism.languages.latex;
}(Prism));

/* FIXME :
 :extend() is not handled specifically : its highlighting is buggy.
 Mixin usage must be inside a ruleset to be highlighted.
 At-rules (e.g. import) containing interpolations are buggy.
 Detached rulesets are highlighted as at-rules.
 A comment before a mixin usage prevents the latter to be properly highlighted.
 */

Prism.languages.less = Prism.languages.extend('css', {
	'comment': [
		/\/\*[\s\S]*?\*\//,
		{
			pattern: /(^|[^\\])\/\/.*/,
			lookbehind: true
		}
	],
	'atrule': {
		pattern: /@[\w-](?:\((?:[^(){}]|\([^(){}]*\))*\)|[^(){};\s]|\s+(?!\s))*?(?=\s*\{)/,
		inside: {
			'punctuation': /[:()]/
		}
	},
	// selectors and mixins are considered the same
	'selector': {
		pattern: /(?:@\{[\w-]+\}|[^{};\s@])(?:@\{[\w-]+\}|\((?:[^(){}]|\([^(){}]*\))*\)|[^(){};@\s]|\s+(?!\s))*?(?=\s*\{)/,
		inside: {
			// mixin parameters
			'variable': /@+[\w-]+/
		}
	},

	'property': /(?:@\{[\w-]+\}|[\w-])+(?:\+_?)?(?=\s*:)/,
	'operator': /[+\-*\/]/
});

Prism.languages.insertBefore('less', 'property', {
	'variable': [
		// Variable declaration (the colon must be consumed!)
		{
			pattern: /@[\w-]+\s*:/,
			inside: {
				'punctuation': /:/
			}
		},

		// Variable usage
		/@@?[\w-]+/
	],
	'mixin-usage': {
		pattern: /([{;]\s*)[.#](?!\d)[\w-].*?(?=[(;])/,
		lookbehind: true,
		alias: 'function'
	}
});

(function (Prism) {
	/**
	 * Functions to construct regular expressions
	 * e.g. (interactive ... or (interactive)
	 *
	 * @param {string} name
	 * @returns {RegExp}
	 */
	function simple_form(name) {
		return RegExp(/(\()/.source + '(?:' + name + ')' + /(?=[\s\)])/.source);
	}
	/**
	 * booleans and numbers
	 *
	 * @param {string} pattern
	 * @returns {RegExp}
	 */
	function primitive(pattern) {
		return RegExp(/([\s([])/.source + '(?:' + pattern + ')' + /(?=[\s)])/.source);
	}

	// Patterns in regular expressions

	// Symbol name. See https://www.gnu.org/software/emacs/manual/html_node/elisp/Symbol-Type.html
	// & and : are excluded as they are usually used for special purposes
	var symbol = /(?!\d)[-+*/~!@$%^=<>{}\w]+/.source;
	// symbol starting with & used in function arguments
	var marker = '&' + symbol;
	// Open parenthesis for look-behind
	var par = '(\\()';
	var endpar = '(?=\\))';
	// End the pattern with look-ahead space
	var space = '(?=\\s)';
	var nestedPar = /(?:[^()]|\((?:[^()]|\((?:[^()]|\((?:[^()]|\((?:[^()]|\([^()]*\))*\))*\))*\))*\))*/.source;

	var language = {
		// Three or four semicolons are considered a heading.
		// See https://www.gnu.org/software/emacs/manual/html_node/elisp/Comment-Tips.html
		heading: {
			pattern: /;;;.*/,
			alias: ['comment', 'title']
		},
		comment: /;.*/,
		string: {
			pattern: /"(?:[^"\\]|\\.)*"/,
			greedy: true,
			inside: {
				argument: /[-A-Z]+(?=[.,\s])/,
				symbol: RegExp('`' + symbol + "'")
			}
		},
		'quoted-symbol': {
			pattern: RegExp("#?'" + symbol),
			alias: ['variable', 'symbol']
		},
		'lisp-property': {
			pattern: RegExp(':' + symbol),
			alias: 'property'
		},
		splice: {
			pattern: RegExp(',@?' + symbol),
			alias: ['symbol', 'variable']
		},
		keyword: [
			{
				pattern: RegExp(
					par +
						'(?:and|(?:cl-)?letf|cl-loop|cond|cons|error|if|(?:lexical-)?let\\*?|message|not|null|or|provide|require|setq|unless|use-package|when|while)' +
						space
				),
				lookbehind: true
			},
			{
				pattern: RegExp(
					par + '(?:append|by|collect|concat|do|finally|for|in|return)' + space
				),
				lookbehind: true
			},
		],
		declare: {
			pattern: simple_form(/declare/.source),
			lookbehind: true,
			alias: 'keyword'
		},
		interactive: {
			pattern: simple_form(/interactive/.source),
			lookbehind: true,
			alias: 'keyword'
		},
		boolean: {
			pattern: primitive(/nil|t/.source),
			lookbehind: true
		},
		number: {
			pattern: primitive(/[-+]?\d+(?:\.\d*)?/.source),
			lookbehind: true
		},
		defvar: {
			pattern: RegExp(par + 'def(?:const|custom|group|var)\\s+' + symbol),
			lookbehind: true,
			inside: {
				keyword: /^def[a-z]+/,
				variable: RegExp(symbol)
			}
		},
		defun: {
			pattern: RegExp(par + /(?:cl-)?(?:defmacro|defun\*?)\s+/.source + symbol + /\s+\(/.source + nestedPar + /\)/.source),
			lookbehind: true,
			greedy: true,
			inside: {
				keyword: /^(?:cl-)?def\S+/,
				// See below, this property needs to be defined later so that it can
				// reference the language object.
				arguments: null,
				function: {
					pattern: RegExp('(^\\s)' + symbol),
					lookbehind: true
				},
				punctuation: /[()]/
			}
		},
		lambda: {
			pattern: RegExp(par + 'lambda\\s+\\(\\s*(?:&?' + symbol + '(?:\\s+&?' + symbol + ')*\\s*)?\\)'),
			lookbehind: true,
			greedy: true,
			inside: {
				keyword: /^lambda/,
				// See below, this property needs to be defined later so that it can
				// reference the language object.
				arguments: null,
				punctuation: /[()]/
			}
		},
		car: {
			pattern: RegExp(par + symbol),
			lookbehind: true
		},
		punctuation: [
			// open paren, brackets, and close paren
			/(?:['`,]?\(|[)\[\]])/,
			// cons
			{
				pattern: /(\s)\.(?=\s)/,
				lookbehind: true
			},
		]
	};

	var arg = {
		'lisp-marker': RegExp(marker),
		'varform': {
			pattern: RegExp(/\(/.source + symbol + /\s+(?=\S)/.source + nestedPar + /\)/.source),
			inside: language
		},
		'argument': {
			pattern: RegExp(/(^|[\s(])/.source + symbol),
			lookbehind: true,
			alias: 'variable'
		},
		rest: language
	};

	var forms = '\\S+(?:\\s+\\S+)*';

	var arglist = {
		pattern: RegExp(par + nestedPar + endpar),
		lookbehind: true,
		inside: {
			'rest-vars': {
				pattern: RegExp('&(?:body|rest)\\s+' + forms),
				inside: arg
			},
			'other-marker-vars': {
				pattern: RegExp('&(?:aux|optional)\\s+' + forms),
				inside: arg
			},
			keys: {
				pattern: RegExp('&key\\s+' + forms + '(?:\\s+&allow-other-keys)?'),
				inside: arg
			},
			argument: {
				pattern: RegExp(symbol),
				alias: 'variable'
			},
			punctuation: /[()]/
		}
	};

	language['lambda'].inside.arguments = arglist;
	language['defun'].inside.arguments = Prism.util.clone(arglist);
	language['defun'].inside.arguments.inside.sublist = arglist;

	Prism.languages.lisp = language;
	Prism.languages.elisp = language;
	Prism.languages.emacs = language;
	Prism.languages['emacs-lisp'] = language;
}(Prism));

Prism.languages.makefile = {
	'comment': {
		pattern: /(^|[^\\])#(?:\\(?:\r\n|[\s\S])|[^\\\r\n])*/,
		lookbehind: true
	},
	'string': {
		pattern: /(["'])(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1/,
		greedy: true
	},

	'builtin-target': {
		pattern: /\.[A-Z][^:#=\s]+(?=\s*:(?!=))/,
		alias: 'builtin'
	},

	'target': {
		pattern: /^(?:[^:=\s]|[ \t]+(?![\s:]))+(?=\s*:(?!=))/m,
		alias: 'symbol',
		inside: {
			'variable': /\$+(?:(?!\$)[^(){}:#=\s]+|(?=[({]))/
		}
	},
	'variable': /\$+(?:(?!\$)[^(){}:#=\s]+|\([@*%<^+?][DF]\)|(?=[({]))/,

	// Directives
	'keyword': /-include\b|\b(?:define|else|endef|endif|export|ifn?def|ifn?eq|include|override|private|sinclude|undefine|unexport|vpath)\b/,

	'function': {
		pattern: /(\()(?:abspath|addsuffix|and|basename|call|dir|error|eval|file|filter(?:-out)?|findstring|firstword|flavor|foreach|guile|if|info|join|lastword|load|notdir|or|origin|patsubst|realpath|shell|sort|strip|subst|suffix|value|warning|wildcard|word(?:list|s)?)(?=[ \t])/,
		lookbehind: true
	},
	'operator': /(?:::|[?:+!])?=|[|@]/,
	'punctuation': /[:;(){}]/
};

(function (Prism) {

	// Allow only one line break
	var inner = /(?:\\.|[^\\\n\r]|(?:\n|\r\n?)(?![\r\n]))/.source;

	/**
	 * This function is intended for the creation of the bold or italic pattern.
	 *
	 * This also adds a lookbehind group to the given pattern to ensure that the pattern is not backslash-escaped.
	 *
	 * _Note:_ Keep in mind that this adds a capturing group.
	 *
	 * @param {string} pattern
	 * @returns {RegExp}
	 */
	function createInline(pattern) {
		pattern = pattern.replace(/<inner>/g, function () { return inner; });
		return RegExp(/((?:^|[^\\])(?:\\{2})*)/.source + '(?:' + pattern + ')');
	}


	var tableCell = /(?:\\.|``(?:[^`\r\n]|`(?!`))+``|`[^`\r\n]+`|[^\\|\r\n`])+/.source;
	var tableRow = /\|?__(?:\|__)+\|?(?:(?:\n|\r\n?)|(?![\s\S]))/.source.replace(/__/g, function () { return tableCell; });
	var tableLine = /\|?[ \t]*:?-{3,}:?[ \t]*(?:\|[ \t]*:?-{3,}:?[ \t]*)+\|?(?:\n|\r\n?)/.source;


	Prism.languages.markdown = Prism.languages.extend('markup', {});
	Prism.languages.insertBefore('markdown', 'prolog', {
		'front-matter-block': {
			pattern: /(^(?:\s*[\r\n])?)---(?!.)[\s\S]*?[\r\n]---(?!.)/,
			lookbehind: true,
			greedy: true,
			inside: {
				'punctuation': /^---|---$/,
				'front-matter': {
					pattern: /\S+(?:\s+\S+)*/,
					alias: ['yaml', 'language-yaml'],
					inside: Prism.languages.yaml
				}
			}
		},
		'blockquote': {
			// > ...
			pattern: /^>(?:[\t ]*>)*/m,
			alias: 'punctuation'
		},
		'table': {
			pattern: RegExp('^' + tableRow + tableLine + '(?:' + tableRow + ')*', 'm'),
			inside: {
				'table-data-rows': {
					pattern: RegExp('^(' + tableRow + tableLine + ')(?:' + tableRow + ')*$'),
					lookbehind: true,
					inside: {
						'table-data': {
							pattern: RegExp(tableCell),
							inside: Prism.languages.markdown
						},
						'punctuation': /\|/
					}
				},
				'table-line': {
					pattern: RegExp('^(' + tableRow + ')' + tableLine + '$'),
					lookbehind: true,
					inside: {
						'punctuation': /\||:?-{3,}:?/
					}
				},
				'table-header-row': {
					pattern: RegExp('^' + tableRow + '$'),
					inside: {
						'table-header': {
							pattern: RegExp(tableCell),
							alias: 'important',
							inside: Prism.languages.markdown
						},
						'punctuation': /\|/
					}
				}
			}
		},
		'code': [
			{
				// Prefixed by 4 spaces or 1 tab and preceded by an empty line
				pattern: /((?:^|\n)[ \t]*\n|(?:^|\r\n?)[ \t]*\r\n?)(?: {4}|\t).+(?:(?:\n|\r\n?)(?: {4}|\t).+)*/,
				lookbehind: true,
				alias: 'keyword'
			},
			{
				// ```optional language
				// code block
				// ```
				pattern: /^```[\s\S]*?^```$/m,
				greedy: true,
				inside: {
					'code-block': {
						pattern: /^(```.*(?:\n|\r\n?))[\s\S]+?(?=(?:\n|\r\n?)^```$)/m,
						lookbehind: true
					},
					'code-language': {
						pattern: /^(```).+/,
						lookbehind: true
					},
					'punctuation': /```/
				}
			}
		],
		'title': [
			{
				// title 1
				// =======

				// title 2
				// -------
				pattern: /\S.*(?:\n|\r\n?)(?:==+|--+)(?=[ \t]*$)/m,
				alias: 'important',
				inside: {
					punctuation: /==+$|--+$/
				}
			},
			{
				// # title 1
				// ###### title 6
				pattern: /(^\s*)#.+/m,
				lookbehind: true,
				alias: 'important',
				inside: {
					punctuation: /^#+|#+$/
				}
			}
		],
		'hr': {
			// ***
			// ---
			// * * *
			// -----------
			pattern: /(^\s*)([*-])(?:[\t ]*\2){2,}(?=\s*$)/m,
			lookbehind: true,
			alias: 'punctuation'
		},
		'list': {
			// * item
			// + item
			// - item
			// 1. item
			pattern: /(^\s*)(?:[*+-]|\d+\.)(?=[\t ].)/m,
			lookbehind: true,
			alias: 'punctuation'
		},
		'url-reference': {
			// [id]: http://example.com "Optional title"
			// [id]: http://example.com 'Optional title'
			// [id]: http://example.com (Optional title)
			// [id]: <http://example.com> "Optional title"
			pattern: /!?\[[^\]]+\]:[\t ]+(?:\S+|<(?:\\.|[^>\\])+>)(?:[\t ]+(?:"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|\((?:\\.|[^)\\])*\)))?/,
			inside: {
				'variable': {
					pattern: /^(!?\[)[^\]]+/,
					lookbehind: true
				},
				'string': /(?:"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|\((?:\\.|[^)\\])*\))$/,
				'punctuation': /^[\[\]!:]|[<>]/
			},
			alias: 'url'
		},
		'bold': {
			// **strong**
			// __strong__

			// allow one nested instance of italic text using the same delimiter
			pattern: createInline(/\b__(?:(?!_)<inner>|_(?:(?!_)<inner>)+_)+__\b|\*\*(?:(?!\*)<inner>|\*(?:(?!\*)<inner>)+\*)+\*\*/.source),
			lookbehind: true,
			greedy: true,
			inside: {
				'content': {
					pattern: /(^..)[\s\S]+(?=..$)/,
					lookbehind: true,
					inside: {} // see below
				},
				'punctuation': /\*\*|__/
			}
		},
		'italic': {
			// *em*
			// _em_

			// allow one nested instance of bold text using the same delimiter
			pattern: createInline(/\b_(?:(?!_)<inner>|__(?:(?!_)<inner>)+__)+_\b|\*(?:(?!\*)<inner>|\*\*(?:(?!\*)<inner>)+\*\*)+\*/.source),
			lookbehind: true,
			greedy: true,
			inside: {
				'content': {
					pattern: /(^.)[\s\S]+(?=.$)/,
					lookbehind: true,
					inside: {} // see below
				},
				'punctuation': /[*_]/
			}
		},
		'strike': {
			// ~~strike through~~
			// ~strike~
			// eslint-disable-next-line regexp/strict
			pattern: createInline(/(~~?)(?:(?!~)<inner>)+\2/.source),
			lookbehind: true,
			greedy: true,
			inside: {
				'content': {
					pattern: /(^~~?)[\s\S]+(?=\1$)/,
					lookbehind: true,
					inside: {} // see below
				},
				'punctuation': /~~?/
			}
		},
		'code-snippet': {
			// `code`
			// ``code``
			pattern: /(^|[^\\`])(?:``[^`\r\n]+(?:`[^`\r\n]+)*``(?!`)|`[^`\r\n]+`(?!`))/,
			lookbehind: true,
			greedy: true,
			alias: ['code', 'keyword']
		},
		'url': {
			// [example](http://example.com "Optional title")
			// [example][id]
			// [example] [id]
			pattern: createInline(/!?\[(?:(?!\])<inner>)+\](?:\([^\s)]+(?:[\t ]+"(?:\\.|[^"\\])*")?\)|[ \t]?\[(?:(?!\])<inner>)+\])/.source),
			lookbehind: true,
			greedy: true,
			inside: {
				'operator': /^!/,
				'content': {
					pattern: /(^\[)[^\]]+(?=\])/,
					lookbehind: true,
					inside: {} // see below
				},
				'variable': {
					pattern: /(^\][ \t]?\[)[^\]]+(?=\]$)/,
					lookbehind: true
				},
				'url': {
					pattern: /(^\]\()[^\s)]+/,
					lookbehind: true
				},
				'string': {
					pattern: /(^[ \t]+)"(?:\\.|[^"\\])*"(?=\)$)/,
					lookbehind: true
				}
			}
		}
	});

	['url', 'bold', 'italic', 'strike'].forEach(function (token) {
		['url', 'bold', 'italic', 'strike', 'code-snippet'].forEach(function (inside) {
			if (token !== inside) {
				Prism.languages.markdown[token].inside.content.inside[inside] = Prism.languages.markdown[inside];
			}
		});
	});

	Prism.hooks.add('after-tokenize', function (env) {
		if (env.language !== 'markdown' && env.language !== 'md') {
			return;
		}

		function walkTokens(tokens) {
			if (!tokens || typeof tokens === 'string') {
				return;
			}

			for (var i = 0, l = tokens.length; i < l; i++) {
				var token = tokens[i];

				if (token.type !== 'code') {
					walkTokens(token.content);
					continue;
				}

				/*
				 * Add the correct `language-xxxx` class to this code block. Keep in mind that the `code-language` token
				 * is optional. But the grammar is defined so that there is only one case we have to handle:
				 *
				 * token.content = [
				 *     <span class="punctuation">```</span>,
				 *     <span class="code-language">xxxx</span>,
				 *     '\n', // exactly one new lines (\r or \n or \r\n)
				 *     <span class="code-block">...</span>,
				 *     '\n', // exactly one new lines again
				 *     <span class="punctuation">```</span>
				 * ];
				 */

				var codeLang = token.content[1];
				var codeBlock = token.content[3];

				if (codeLang && codeBlock &&
					codeLang.type === 'code-language' && codeBlock.type === 'code-block' &&
					typeof codeLang.content === 'string') {

					// this might be a language that Prism does not support

					// do some replacements to support C++, C#, and F#
					var lang = codeLang.content.replace(/\b#/g, 'sharp').replace(/\b\+\+/g, 'pp');
					// only use the first word
					lang = (/[a-z][\w-]*/i.exec(lang) || [''])[0].toLowerCase();
					var alias = 'language-' + lang;

					// add alias
					if (!codeBlock.alias) {
						codeBlock.alias = [alias];
					} else if (typeof codeBlock.alias === 'string') {
						codeBlock.alias = [codeBlock.alias, alias];
					} else {
						codeBlock.alias.push(alias);
					}
				}
			}
		}

		walkTokens(env.tokens);
	});

	Prism.hooks.add('wrap', function (env) {
		if (env.type !== 'code-block') {
			return;
		}

		var codeLang = '';
		for (var i = 0, l = env.classes.length; i < l; i++) {
			var cls = env.classes[i];
			var match = /language-(.+)/.exec(cls);
			if (match) {
				codeLang = match[1];
				break;
			}
		}

		var grammar = Prism.languages[codeLang];

		if (!grammar) {
			if (codeLang && codeLang !== 'none' && Prism.plugins.autoloader) {
				var id = 'md-' + new Date().valueOf() + '-' + Math.floor(Math.random() * 1e16);
				env.attributes['id'] = id;

				Prism.plugins.autoloader.loadLanguages(codeLang, function () {
					var ele = document.getElementById(id);
					if (ele) {
						ele.innerHTML = Prism.highlight(ele.textContent, Prism.languages[codeLang], codeLang);
					}
				});
			}
		} else {
			env.content = Prism.highlight(textContent(env.content), grammar, codeLang);
		}
	});

	var tagPattern = RegExp(Prism.languages.markup.tag.pattern.source, 'gi');

	/**
	 * A list of known entity names.
	 *
	 * This will always be incomplete to save space. The current list is the one used by lowdash's unescape function.
	 *
	 * @see {@link https://github.com/lodash/lodash/blob/2da024c3b4f9947a48517639de7560457cd4ec6c/unescape.js#L2}
	 */
	var KNOWN_ENTITY_NAMES = {
		'amp': '&',
		'lt': '<',
		'gt': '>',
		'quot': '"',
	};

	// IE 11 doesn't support `String.fromCodePoint`
	var fromCodePoint = String.fromCodePoint || String.fromCharCode;

	/**
	 * Returns the text content of a given HTML source code string.
	 *
	 * @param {string} html
	 * @returns {string}
	 */
	function textContent(html) {
		// remove all tags
		var text = html.replace(tagPattern, '');

		// decode known entities
		text = text.replace(/&(\w{1,8}|#x?[\da-f]{1,8});/gi, function (m, code) {
			code = code.toLowerCase();

			if (code[0] === '#') {
				var value;
				if (code[1] === 'x') {
					value = parseInt(code.slice(2), 16);
				} else {
					value = Number(code.slice(1));
				}

				return fromCodePoint(value);
			} else {
				var known = KNOWN_ENTITY_NAMES[code];
				if (known) {
					return known;
				}

				// unable to decode
				return m;
			}
		});

		return text;
	}

	Prism.languages.md = Prism.languages.markdown;

}(Prism));

Prism.languages.matlab = {
	'comment': [
		/%\{[\s\S]*?\}%/,
		/%.+/
	],
	'string': {
		pattern: /\B'(?:''|[^'\r\n])*'/,
		greedy: true
	},
	// FIXME We could handle imaginary numbers as a whole
	'number': /(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:[eE][+-]?\d+)?(?:[ij])?|\b[ij]\b/,
	'keyword': /\b(?:NaN|break|case|catch|continue|else|elseif|end|for|function|if|inf|otherwise|parfor|pause|pi|return|switch|try|while)\b/,
	'function': /\b(?!\d)\w+(?=\s*\()/,
	'operator': /\.?[*^\/\\']|[+\-:@]|[<>=~]=?|&&?|\|\|?/,
	'punctuation': /\.{3}|[.,;\[\](){}!]/
};

(function (Prism) {

	var operators = [
		// query and projection
		'$eq', '$gt', '$gte', '$in', '$lt', '$lte', '$ne', '$nin', '$and', '$not', '$nor', '$or',
		'$exists', '$type', '$expr', '$jsonSchema', '$mod', '$regex', '$text', '$where', '$geoIntersects',
		'$geoWithin', '$near', '$nearSphere', '$all', '$elemMatch', '$size', '$bitsAllClear', '$bitsAllSet',
		'$bitsAnyClear', '$bitsAnySet', '$comment', '$elemMatch', '$meta', '$slice',

		// update
		'$currentDate', '$inc', '$min', '$max', '$mul', '$rename', '$set', '$setOnInsert', '$unset',
		'$addToSet', '$pop', '$pull', '$push', '$pullAll', '$each', '$position', '$slice', '$sort', '$bit',

		// aggregation pipeline stages
		'$addFields', '$bucket', '$bucketAuto', '$collStats', '$count', '$currentOp', '$facet', '$geoNear',
		'$graphLookup', '$group', '$indexStats', '$limit', '$listLocalSessions', '$listSessions', '$lookup',
		'$match', '$merge', '$out', '$planCacheStats', '$project', '$redact', '$replaceRoot', '$replaceWith',
		'$sample', '$set', '$skip', '$sort', '$sortByCount', '$unionWith', '$unset', '$unwind', '$setWindowFields',

		// aggregation pipeline operators
		'$abs', '$accumulator', '$acos', '$acosh', '$add', '$addToSet', '$allElementsTrue', '$and',
		'$anyElementTrue', '$arrayElemAt', '$arrayToObject', '$asin', '$asinh', '$atan', '$atan2',
		'$atanh', '$avg', '$binarySize', '$bsonSize', '$ceil', '$cmp', '$concat', '$concatArrays', '$cond',
		'$convert', '$cos', '$dateFromParts', '$dateToParts', '$dateFromString', '$dateToString', '$dayOfMonth',
		'$dayOfWeek', '$dayOfYear', '$degreesToRadians', '$divide', '$eq', '$exp', '$filter', '$first',
		'$floor', '$function', '$gt', '$gte', '$hour', '$ifNull', '$in', '$indexOfArray', '$indexOfBytes',
		'$indexOfCP', '$isArray', '$isNumber', '$isoDayOfWeek', '$isoWeek', '$isoWeekYear', '$last',
		'$last', '$let', '$literal', '$ln', '$log', '$log10', '$lt', '$lte', '$ltrim', '$map', '$max',
		'$mergeObjects', '$meta', '$min', '$millisecond', '$minute', '$mod', '$month', '$multiply', '$ne',
		'$not', '$objectToArray', '$or', '$pow', '$push', '$radiansToDegrees', '$range', '$reduce',
		'$regexFind', '$regexFindAll', '$regexMatch', '$replaceOne', '$replaceAll', '$reverseArray', '$round',
		'$rtrim', '$second', '$setDifference', '$setEquals', '$setIntersection', '$setIsSubset', '$setUnion',
		'$size', '$sin', '$slice', '$split', '$sqrt', '$stdDevPop', '$stdDevSamp', '$strcasecmp', '$strLenBytes',
		'$strLenCP', '$substr', '$substrBytes', '$substrCP', '$subtract', '$sum', '$switch', '$tan',
		'$toBool', '$toDate', '$toDecimal', '$toDouble', '$toInt', '$toLong', '$toObjectId', '$toString',
		'$toLower', '$toUpper', '$trim', '$trunc', '$type', '$week', '$year', '$zip', '$count', '$dateAdd',
		'$dateDiff', '$dateSubtract', '$dateTrunc', '$getField', '$rand', '$sampleRate', '$setField', '$unsetField',

		// aggregation pipeline query modifiers
		'$comment', '$explain', '$hint', '$max', '$maxTimeMS', '$min', '$orderby', '$query',
		'$returnKey', '$showDiskLoc', '$natural',
	];

	var builtinFunctions = [
		'ObjectId',
		'Code',
		'BinData',
		'DBRef',
		'Timestamp',
		'NumberLong',
		'NumberDecimal',
		'MaxKey',
		'MinKey',
		'RegExp',
		'ISODate',
		'UUID',
	];

	operators = operators.map(function (operator) {
		return operator.replace('$', '\\$');
	});

	var operatorsSource = '(?:' + operators.join('|') + ')\\b';

	Prism.languages.mongodb = Prism.languages.extend('javascript', {});

	Prism.languages.insertBefore('mongodb', 'string', {
		'property': {
			pattern: /(?:(["'])(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1|(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*)(?=\s*:)/,
			greedy: true,
			inside: {
				'keyword': RegExp('^([\'"])?' + operatorsSource + '(?:\\1)?$')
			}
		}
	});

	Prism.languages.mongodb.string.inside = {
		url: {
			// url pattern
			pattern: /https?:\/\/[-\w@:%.+~#=]{1,256}\.[a-z0-9()]{1,6}\b[-\w()@:%+.~#?&/=]*/i,
			greedy: true
		},
		entity: {
			// ipv4
			pattern: /\b(?:(?:[01]?\d\d?|2[0-4]\d|25[0-5])\.){3}(?:[01]?\d\d?|2[0-4]\d|25[0-5])\b/,
			greedy: true
		}
	};

	Prism.languages.insertBefore('mongodb', 'constant', {
		'builtin': {
			pattern: RegExp('\\b(?:' + builtinFunctions.join('|') + ')\\b'),
			alias: 'keyword'
		}
	});

}(Prism));

(function (Prism) {

	var variable = /\$(?:\w[a-z\d]*(?:_[^\x00-\x1F\s"'\\()$]*)?|\{[^}\s"'\\]+\})/i;

	Prism.languages.nginx = {
		'comment': {
			pattern: /(^|[\s{};])#.*/,
			lookbehind: true,
			greedy: true
		},
		'directive': {
			pattern: /(^|\s)\w(?:[^;{}"'\\\s]|\\.|"(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'|\s+(?:#.*(?!.)|(?![#\s])))*?(?=\s*[;{])/,
			lookbehind: true,
			greedy: true,
			inside: {
				'string': {
					pattern: /((?:^|[^\\])(?:\\\\)*)(?:"(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*')/,
					lookbehind: true,
					greedy: true,
					inside: {
						'escape': {
							pattern: /\\["'\\nrt]/,
							alias: 'entity'
						},
						'variable': variable
					}
				},
				'comment': {
					pattern: /(\s)#.*/,
					lookbehind: true,
					greedy: true
				},
				'keyword': {
					pattern: /^\S+/,
					greedy: true
				},

				// other patterns

				'boolean': {
					pattern: /(\s)(?:off|on)(?!\S)/,
					lookbehind: true
				},
				'number': {
					pattern: /(\s)\d+[a-z]*(?!\S)/i,
					lookbehind: true
				},
				'variable': variable
			}
		},
		'punctuation': /[{};]/
	};

}(Prism));

Prism.languages.nix = {
	'comment': {
		pattern: /\/\*[\s\S]*?\*\/|#.*/,
		greedy: true
	},
	'string': {
		pattern: /"(?:[^"\\]|\\[\s\S])*"|''(?:(?!'')[\s\S]|''(?:'|\\|\$\{))*''/,
		greedy: true,
		inside: {
			'interpolation': {
				// The lookbehind ensures the ${} is not preceded by \ or ''
				pattern: /(^|(?:^|(?!'').)[^\\])\$\{(?:[^{}]|\{[^}]*\})*\}/,
				lookbehind: true,
				inside: null // see below
			}
		}
	},
	'url': [
		/\b(?:[a-z]{3,7}:\/\/)[\w\-+%~\/.:#=?&]+/,
		{
			pattern: /([^\/])(?:[\w\-+%~.:#=?&]*(?!\/\/)[\w\-+%~\/.:#=?&])?(?!\/\/)\/[\w\-+%~\/.:#=?&]*/,
			lookbehind: true
		}
	],
	'antiquotation': {
		pattern: /\$(?=\{)/,
		alias: 'important'
	},
	'number': /\b\d+\b/,
	'keyword': /\b(?:assert|builtins|else|if|in|inherit|let|null|or|then|with)\b/,
	'function': /\b(?:abort|add|all|any|attrNames|attrValues|baseNameOf|compareVersions|concatLists|currentSystem|deepSeq|derivation|dirOf|div|elem(?:At)?|fetch(?:Tarball|url)|filter(?:Source)?|fromJSON|genList|getAttr|getEnv|hasAttr|hashString|head|import|intersectAttrs|is(?:Attrs|Bool|Function|Int|List|Null|String)|length|lessThan|listToAttrs|map|mul|parseDrvName|pathExists|read(?:Dir|File)|removeAttrs|replaceStrings|seq|sort|stringLength|sub(?:string)?|tail|throw|to(?:File|JSON|Path|String|XML)|trace|typeOf)\b|\bfoldl'\B/,
	'boolean': /\b(?:false|true)\b/,
	'operator': /[=!<>]=?|\+\+?|\|\||&&|\/\/|->?|[?@]/,
	'punctuation': /[{}()[\].,:;]/
};

Prism.languages.nix.string.inside.interpolation.inside = Prism.languages.nix;

// Based on Free Pascal

/* TODO
	Support inline asm ?
*/

Prism.languages.pascal = {
	'directive': {
		pattern: /\{\$[\s\S]*?\}/,
		greedy: true,
		alias: ['marco', 'property']
	},
	'comment': {
		pattern: /\(\*[\s\S]*?\*\)|\{[\s\S]*?\}|\/\/.*/,
		greedy: true
	},
	'string': {
		pattern: /(?:'(?:''|[^'\r\n])*'(?!')|#[&$%]?[a-f\d]+)+|\^[a-z]/i,
		greedy: true
	},
	'asm': {
		pattern: /(\basm\b)[\s\S]+?(?=\bend\s*[;[])/i,
		lookbehind: true,
		greedy: true,
		inside: null // see below
	},
	'keyword': [
		{
			// Turbo Pascal
			pattern: /(^|[^&])\b(?:absolute|array|asm|begin|case|const|constructor|destructor|do|downto|else|end|file|for|function|goto|if|implementation|inherited|inline|interface|label|nil|object|of|operator|packed|procedure|program|record|reintroduce|repeat|self|set|string|then|to|type|unit|until|uses|var|while|with)\b/i,
			lookbehind: true
		},
		{
			// Free Pascal
			pattern: /(^|[^&])\b(?:dispose|exit|false|new|true)\b/i,
			lookbehind: true
		},
		{
			// Object Pascal
			pattern: /(^|[^&])\b(?:class|dispinterface|except|exports|finalization|finally|initialization|inline|library|on|out|packed|property|raise|resourcestring|threadvar|try)\b/i,
			lookbehind: true
		},
		{
			// Modifiers
			pattern: /(^|[^&])\b(?:absolute|abstract|alias|assembler|bitpacked|break|cdecl|continue|cppdecl|cvar|default|deprecated|dynamic|enumerator|experimental|export|external|far|far16|forward|generic|helper|implements|index|interrupt|iochecks|local|message|name|near|nodefault|noreturn|nostackframe|oldfpccall|otherwise|overload|override|pascal|platform|private|protected|public|published|read|register|reintroduce|result|safecall|saveregisters|softfloat|specialize|static|stdcall|stored|strict|unaligned|unimplemented|varargs|virtual|write)\b/i,
			lookbehind: true
		}
	],
	'number': [
		// Hexadecimal, octal and binary
		/(?:[&%]\d+|\$[a-f\d]+)/i,
		// Decimal
		/\b\d+(?:\.\d+)?(?:e[+-]?\d+)?/i
	],
	'operator': [
		/\.\.|\*\*|:=|<[<=>]?|>[>=]?|[+\-*\/]=?|[@^=]/,
		{
			pattern: /(^|[^&])\b(?:and|as|div|exclude|in|include|is|mod|not|or|shl|shr|xor)\b/,
			lookbehind: true
		}
	],
	'punctuation': /\(\.|\.\)|[()\[\]:;,.]/
};

Prism.languages.pascal.asm.inside = Prism.languages.extend('pascal', {
	'asm': undefined,
	'keyword': undefined,
	'operator': undefined
});

Prism.languages.objectpascal = Prism.languages.pascal;

(function (Prism) {

	var brackets = /(?:\((?:[^()\\]|\\[\s\S])*\)|\{(?:[^{}\\]|\\[\s\S])*\}|\[(?:[^[\]\\]|\\[\s\S])*\]|<(?:[^<>\\]|\\[\s\S])*>)/.source;

	Prism.languages.perl = {
		'comment': [
			{
				// POD
				pattern: /(^\s*)=\w[\s\S]*?=cut.*/m,
				lookbehind: true,
				greedy: true
			},
			{
				pattern: /(^|[^\\$])#.*/,
				lookbehind: true,
				greedy: true
			}
		],
		// TODO Could be nice to handle Heredoc too.
		'string': [
			{
				pattern: RegExp(
					/\b(?:q|qq|qw|qx)(?![a-zA-Z0-9])\s*/.source +
					'(?:' +
					[
						// q/.../
						/([^a-zA-Z0-9\s{(\[<])(?:(?!\1)[^\\]|\\[\s\S])*\1/.source,

						// q a...a
						// eslint-disable-next-line regexp/strict
						/([a-zA-Z0-9])(?:(?!\2)[^\\]|\\[\s\S])*\2/.source,

						// q(...)
						// q{...}
						// q[...]
						// q<...>
						brackets,
					].join('|') +
					')'
				),
				greedy: true
			},

			// "...", `...`
			{
				pattern: /("|`)(?:(?!\1)[^\\]|\\[\s\S])*\1/,
				greedy: true
			},

			// '...'
			// FIXME Multi-line single-quoted strings are not supported as they would break variables containing '
			{
				pattern: /'(?:[^'\\\r\n]|\\.)*'/,
				greedy: true
			}
		],
		'regex': [
			{
				pattern: RegExp(
					/\b(?:m|qr)(?![a-zA-Z0-9])\s*/.source +
					'(?:' +
					[
						// m/.../
						/([^a-zA-Z0-9\s{(\[<])(?:(?!\1)[^\\]|\\[\s\S])*\1/.source,

						// m a...a
						// eslint-disable-next-line regexp/strict
						/([a-zA-Z0-9])(?:(?!\2)[^\\]|\\[\s\S])*\2/.source,

						// m(...)
						// m{...}
						// m[...]
						// m<...>
						brackets,
					].join('|') +
					')' +
					/[msixpodualngc]*/.source
				),
				greedy: true
			},

			// The lookbehinds prevent -s from breaking
			{
				pattern: RegExp(
					/(^|[^-])\b(?:s|tr|y)(?![a-zA-Z0-9])\s*/.source +
					'(?:' +
					[
						// s/.../.../
						// eslint-disable-next-line regexp/strict
						/([^a-zA-Z0-9\s{(\[<])(?:(?!\2)[^\\]|\\[\s\S])*\2(?:(?!\2)[^\\]|\\[\s\S])*\2/.source,

						// s a...a...a
						// eslint-disable-next-line regexp/strict
						/([a-zA-Z0-9])(?:(?!\3)[^\\]|\\[\s\S])*\3(?:(?!\3)[^\\]|\\[\s\S])*\3/.source,

						// s(...)(...)
						// s{...}{...}
						// s[...][...]
						// s<...><...>
						// s(...)[...]
						brackets + /\s*/.source + brackets,
					].join('|') +
					')' +
					/[msixpodualngcer]*/.source
				),
				lookbehind: true,
				greedy: true
			},

			// /.../
			// The look-ahead tries to prevent two divisions on
			// the same line from being highlighted as regex.
			// This does not support multi-line regex.
			{
				pattern: /\/(?:[^\/\\\r\n]|\\.)*\/[msixpodualngc]*(?=\s*(?:$|[\r\n,.;})&|\-+*~<>!?^]|(?:and|cmp|eq|ge|gt|le|lt|ne|not|or|x|xor)\b))/,
				greedy: true
			}
		],

		// FIXME Not sure about the handling of ::, ', and #
		'variable': [
			// ${^POSTMATCH}
			/[&*$@%]\{\^[A-Z]+\}/,
			// $^V
			/[&*$@%]\^[A-Z_]/,
			// ${...}
			/[&*$@%]#?(?=\{)/,
			// $foo
			/[&*$@%]#?(?:(?:::)*'?(?!\d)[\w$]+(?![\w$]))+(?:::)*/,
			// $1
			/[&*$@%]\d+/,
			// $_, @_, %!
			// The negative lookahead prevents from breaking the %= operator
			/(?!%=)[$@%][!"#$%&'()*+,\-.\/:;<=>?@[\\\]^_`{|}~]/
		],
		'filehandle': {
			// <>, <FOO>, _
			pattern: /<(?![<=])\S*?>|\b_\b/,
			alias: 'symbol'
		},
		'v-string': {
			// v1.2, 1.2.3
			pattern: /v\d+(?:\.\d+)*|\d+(?:\.\d+){2,}/,
			alias: 'string'
		},
		'function': {
			pattern: /(\bsub[ \t]+)\w+/,
			lookbehind: true
		},
		'keyword': /\b(?:any|break|continue|default|delete|die|do|else|elsif|eval|for|foreach|given|goto|if|last|local|my|next|our|package|print|redo|require|return|say|state|sub|switch|undef|unless|until|use|when|while)\b/,
		'number': /\b(?:0x[\dA-Fa-f](?:_?[\dA-Fa-f])*|0b[01](?:_?[01])*|(?:(?:\d(?:_?\d)*)?\.)?\d(?:_?\d)*(?:[Ee][+-]?\d+)?)\b/,
		'operator': /-[rwxoRWXOezsfdlpSbctugkTBMAC]\b|\+[+=]?|-[-=>]?|\*\*?=?|\/\/?=?|=[=~>]?|~[~=]?|\|\|?=?|&&?=?|<(?:=>?|<=?)?|>>?=?|![~=]?|[%^]=?|\.(?:=|\.\.?)?|[\\?]|\bx(?:=|\b)|\b(?:and|cmp|eq|ge|gt|le|lt|ne|not|or|xor)\b/,
		'punctuation': /[{}[\];(),:]/
	};

}(Prism));

(function (Prism) {

	var typeExpression = /(?:\b[a-zA-Z]\w*|[|\\[\]])+/.source;

	Prism.languages.phpdoc = Prism.languages.extend('javadoclike', {
		'parameter': {
			pattern: RegExp('(@(?:global|param|property(?:-read|-write)?|var)\\s+(?:' + typeExpression + '\\s+)?)\\$\\w+'),
			lookbehind: true
		}
	});

	Prism.languages.insertBefore('phpdoc', 'keyword', {
		'class-name': [
			{
				pattern: RegExp('(@(?:global|package|param|property(?:-read|-write)?|return|subpackage|throws|var)\\s+)' + typeExpression),
				lookbehind: true,
				inside: {
					'keyword': /\b(?:array|bool|boolean|callback|double|false|float|int|integer|mixed|null|object|resource|self|string|true|void)\b/,
					'punctuation': /[|\\[\]()]/
				}
			}
		],
	});

	Prism.languages.javadoclike.addSupport('php', Prism.languages.phpdoc);

}(Prism));

Prism.languages.insertBefore('php', 'variable', {
	'this': {
		pattern: /\$this\b/,
		alias: 'keyword'
	},
	'global': /\$(?:GLOBALS|HTTP_RAW_POST_DATA|_(?:COOKIE|ENV|FILES|GET|POST|REQUEST|SERVER|SESSION)|argc|argv|http_response_header|php_errormsg)\b/,
	'scope': {
		pattern: /\b[\w\\]+::/,
		inside: {
			'keyword': /\b(?:parent|self|static)\b/,
			'punctuation': /::|\\/
		}
	}
});

Prism.languages.sql = {
	'comment': {
		pattern: /(^|[^\\])(?:\/\*[\s\S]*?\*\/|(?:--|\/\/|#).*)/,
		lookbehind: true
	},
	'variable': [
		{
			pattern: /@(["'`])(?:\\[\s\S]|(?!\1)[^\\])+\1/,
			greedy: true
		},
		/@[\w.$]+/
	],
	'string': {
		pattern: /(^|[^@\\])("|')(?:\\[\s\S]|(?!\2)[^\\]|\2\2)*\2/,
		greedy: true,
		lookbehind: true
	},
	'identifier': {
		pattern: /(^|[^@\\])`(?:\\[\s\S]|[^`\\]|``)*`/,
		greedy: true,
		lookbehind: true,
		inside: {
			'punctuation': /^`|`$/
		}
	},
	'function': /\b(?:AVG|COUNT|FIRST|FORMAT|LAST|LCASE|LEN|MAX|MID|MIN|MOD|NOW|ROUND|SUM|UCASE)(?=\s*\()/i, // Should we highlight user defined functions too?
	'keyword': /\b(?:ACTION|ADD|AFTER|ALGORITHM|ALL|ALTER|ANALYZE|ANY|APPLY|AS|ASC|AUTHORIZATION|AUTO_INCREMENT|BACKUP|BDB|BEGIN|BERKELEYDB|BIGINT|BINARY|BIT|BLOB|BOOL|BOOLEAN|BREAK|BROWSE|BTREE|BULK|BY|CALL|CASCADED?|CASE|CHAIN|CHAR(?:ACTER|SET)?|CHECK(?:POINT)?|CLOSE|CLUSTERED|COALESCE|COLLATE|COLUMNS?|COMMENT|COMMIT(?:TED)?|COMPUTE|CONNECT|CONSISTENT|CONSTRAINT|CONTAINS(?:TABLE)?|CONTINUE|CONVERT|CREATE|CROSS|CURRENT(?:_DATE|_TIME|_TIMESTAMP|_USER)?|CURSOR|CYCLE|DATA(?:BASES?)?|DATE(?:TIME)?|DAY|DBCC|DEALLOCATE|DEC|DECIMAL|DECLARE|DEFAULT|DEFINER|DELAYED|DELETE|DELIMITERS?|DENY|DESC|DESCRIBE|DETERMINISTIC|DISABLE|DISCARD|DISK|DISTINCT|DISTINCTROW|DISTRIBUTED|DO|DOUBLE|DROP|DUMMY|DUMP(?:FILE)?|DUPLICATE|ELSE(?:IF)?|ENABLE|ENCLOSED|END|ENGINE|ENUM|ERRLVL|ERRORS|ESCAPED?|EXCEPT|EXEC(?:UTE)?|EXISTS|EXIT|EXPLAIN|EXTENDED|FETCH|FIELDS|FILE|FILLFACTOR|FIRST|FIXED|FLOAT|FOLLOWING|FOR(?: EACH ROW)?|FORCE|FOREIGN|FREETEXT(?:TABLE)?|FROM|FULL|FUNCTION|GEOMETRY(?:COLLECTION)?|GLOBAL|GOTO|GRANT|GROUP|HANDLER|HASH|HAVING|HOLDLOCK|HOUR|IDENTITY(?:COL|_INSERT)?|IF|IGNORE|IMPORT|INDEX|INFILE|INNER|INNODB|INOUT|INSERT|INT|INTEGER|INTERSECT|INTERVAL|INTO|INVOKER|ISOLATION|ITERATE|JOIN|KEYS?|KILL|LANGUAGE|LAST|LEAVE|LEFT|LEVEL|LIMIT|LINENO|LINES|LINESTRING|LOAD|LOCAL|LOCK|LONG(?:BLOB|TEXT)|LOOP|MATCH(?:ED)?|MEDIUM(?:BLOB|INT|TEXT)|MERGE|MIDDLEINT|MINUTE|MODE|MODIFIES|MODIFY|MONTH|MULTI(?:LINESTRING|POINT|POLYGON)|NATIONAL|NATURAL|NCHAR|NEXT|NO|NONCLUSTERED|NULLIF|NUMERIC|OFF?|OFFSETS?|ON|OPEN(?:DATASOURCE|QUERY|ROWSET)?|OPTIMIZE|OPTION(?:ALLY)?|ORDER|OUT(?:ER|FILE)?|OVER|PARTIAL|PARTITION|PERCENT|PIVOT|PLAN|POINT|POLYGON|PRECEDING|PRECISION|PREPARE|PREV|PRIMARY|PRINT|PRIVILEGES|PROC(?:EDURE)?|PUBLIC|PURGE|QUICK|RAISERROR|READS?|REAL|RECONFIGURE|REFERENCES|RELEASE|RENAME|REPEAT(?:ABLE)?|REPLACE|REPLICATION|REQUIRE|RESIGNAL|RESTORE|RESTRICT|RETURN(?:ING|S)?|REVOKE|RIGHT|ROLLBACK|ROUTINE|ROW(?:COUNT|GUIDCOL|S)?|RTREE|RULE|SAVE(?:POINT)?|SCHEMA|SECOND|SELECT|SERIAL(?:IZABLE)?|SESSION(?:_USER)?|SET(?:USER)?|SHARE|SHOW|SHUTDOWN|SIMPLE|SMALLINT|SNAPSHOT|SOME|SONAME|SQL|START(?:ING)?|STATISTICS|STATUS|STRIPED|SYSTEM_USER|TABLES?|TABLESPACE|TEMP(?:ORARY|TABLE)?|TERMINATED|TEXT(?:SIZE)?|THEN|TIME(?:STAMP)?|TINY(?:BLOB|INT|TEXT)|TOP?|TRAN(?:SACTIONS?)?|TRIGGER|TRUNCATE|TSEQUAL|TYPES?|UNBOUNDED|UNCOMMITTED|UNDEFINED|UNION|UNIQUE|UNLOCK|UNPIVOT|UNSIGNED|UPDATE(?:TEXT)?|USAGE|USE|USER|USING|VALUES?|VAR(?:BINARY|CHAR|CHARACTER|YING)|VIEW|WAITFOR|WARNINGS|WHEN|WHERE|WHILE|WITH(?: ROLLUP|IN)?|WORK|WRITE(?:TEXT)?|YEAR)\b/i,
	'boolean': /\b(?:FALSE|NULL|TRUE)\b/i,
	'number': /\b0x[\da-f]+\b|\b\d+(?:\.\d*)?|\B\.\d+\b/i,
	'operator': /[-+*\/=%^~]|&&?|\|\|?|!=?|<(?:=>?|<|>)?|>[>=]?|\b(?:AND|BETWEEN|DIV|ILIKE|IN|IS|LIKE|NOT|OR|REGEXP|RLIKE|SOUNDS LIKE|XOR)\b/i,
	'punctuation': /[;[\]()`,.]/
};

Prism.languages.plsql = Prism.languages.extend('sql', {
	'comment': {
		pattern: /\/\*[\s\S]*?\*\/|--.*/,
		greedy: true
	},
	// https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/plsql-reserved-words-keywords.html
	'keyword': /\b(?:A|ACCESSIBLE|ADD|AGENT|AGGREGATE|ALL|ALTER|AND|ANY|ARRAY|AS|ASC|AT|ATTRIBUTE|AUTHID|AVG|BEGIN|BETWEEN|BFILE_BASE|BINARY|BLOB_BASE|BLOCK|BODY|BOTH|BOUND|BULK|BY|BYTE|C|CALL|CALLING|CASCADE|CASE|CHAR|CHARACTER|CHARSET|CHARSETFORM|CHARSETID|CHAR_BASE|CHECK|CLOB_BASE|CLONE|CLOSE|CLUSTER|CLUSTERS|COLAUTH|COLLECT|COLUMNS|COMMENT|COMMIT|COMMITTED|COMPILED|COMPRESS|CONNECT|CONSTANT|CONSTRUCTOR|CONTEXT|CONTINUE|CONVERT|COUNT|CRASH|CREATE|CREDENTIAL|CURRENT|CURSOR|CUSTOMDATUM|DANGLING|DATA|DATE|DATE_BASE|DAY|DECLARE|DEFAULT|DEFINE|DELETE|DESC|DETERMINISTIC|DIRECTORY|DISTINCT|DOUBLE|DROP|DURATION|ELEMENT|ELSE|ELSIF|EMPTY|END|ESCAPE|EXCEPT|EXCEPTION|EXCEPTIONS|EXCLUSIVE|EXECUTE|EXISTS|EXIT|EXTERNAL|FETCH|FINAL|FIRST|FIXED|FLOAT|FOR|FORALL|FORCE|FROM|FUNCTION|GENERAL|GOTO|GRANT|GROUP|HASH|HAVING|HEAP|HIDDEN|HOUR|IDENTIFIED|IF|IMMEDIATE|IMMUTABLE|IN|INCLUDING|INDEX|INDEXES|INDICATOR|INDICES|INFINITE|INSERT|INSTANTIABLE|INT|INTERFACE|INTERSECT|INTERVAL|INTO|INVALIDATE|IS|ISOLATION|JAVA|LANGUAGE|LARGE|LEADING|LENGTH|LEVEL|LIBRARY|LIKE|LIKE2|LIKE4|LIKEC|LIMIT|LIMITED|LOCAL|LOCK|LONG|LOOP|MAP|MAX|MAXLEN|MEMBER|MERGE|MIN|MINUS|MINUTE|MOD|MODE|MODIFY|MONTH|MULTISET|MUTABLE|NAME|NAN|NATIONAL|NATIVE|NCHAR|NEW|NOCOMPRESS|NOCOPY|NOT|NOWAIT|NULL|NUMBER_BASE|OBJECT|OCICOLL|OCIDATE|OCIDATETIME|OCIDURATION|OCIINTERVAL|OCILOBLOCATOR|OCINUMBER|OCIRAW|OCIREF|OCIREFCURSOR|OCIROWID|OCISTRING|OCITYPE|OF|OLD|ON|ONLY|OPAQUE|OPEN|OPERATOR|OPTION|OR|ORACLE|ORADATA|ORDER|ORGANIZATION|ORLANY|ORLVARY|OTHERS|OUT|OVERLAPS|OVERRIDING|PACKAGE|PARALLEL_ENABLE|PARAMETER|PARAMETERS|PARENT|PARTITION|PASCAL|PERSISTABLE|PIPE|PIPELINED|PLUGGABLE|POLYMORPHIC|PRAGMA|PRECISION|PRIOR|PRIVATE|PROCEDURE|PUBLIC|RAISE|RANGE|RAW|READ|RECORD|REF|REFERENCE|RELIES_ON|REM|REMAINDER|RENAME|RESOURCE|RESULT|RESULT_CACHE|RETURN|RETURNING|REVERSE|REVOKE|ROLLBACK|ROW|SAMPLE|SAVE|SAVEPOINT|SB1|SB2|SB4|SECOND|SEGMENT|SELECT|SELF|SEPARATE|SEQUENCE|SERIALIZABLE|SET|SHARE|SHORT|SIZE|SIZE_T|SOME|SPARSE|SQL|SQLCODE|SQLDATA|SQLNAME|SQLSTATE|STANDARD|START|STATIC|STDDEV|STORED|STRING|STRUCT|STYLE|SUBMULTISET|SUBPARTITION|SUBSTITUTABLE|SUBTYPE|SUM|SYNONYM|TABAUTH|TABLE|TDO|THE|THEN|TIME|TIMESTAMP|TIMEZONE_ABBR|TIMEZONE_HOUR|TIMEZONE_MINUTE|TIMEZONE_REGION|TO|TRAILING|TRANSACTION|TRANSACTIONAL|TRUSTED|TYPE|UB1|UB2|UB4|UNDER|UNION|UNIQUE|UNPLUG|UNSIGNED|UNTRUSTED|UPDATE|USE|USING|VALIST|VALUE|VALUES|VARIABLE|VARIANCE|VARRAY|VARYING|VIEW|VIEWS|VOID|WHEN|WHERE|WHILE|WITH|WORK|WRAPPED|WRITE|YEAR|ZONE)\b/i,
	// https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/plsql-language-fundamentals.html#GUID-96A42F7C-7A71-4B90-8255-CA9C8BD9722E
	'operator': /:=?|=>|[<>^~!]=|\.\.|\|\||\*\*|[-+*/%<>=@]/
});

Prism.languages.insertBefore('plsql', 'operator', {
	'label': {
		pattern: /<<\s*\w+\s*>>/,
		alias: 'symbol'
	},
});

// https://docs.microsoft.com/en-us/powerquery-m/power-query-m-language-specification

Prism.languages.powerquery = {
	'comment': {
		pattern: /(^|[^\\])(?:\/\*[\s\S]*?\*\/|\/\/.*)/,
		lookbehind: true,
		greedy: true
	},
	'quoted-identifier': {
		pattern: /#"(?:[^"\r\n]|"")*"(?!")/,
		greedy: true
	},
	'string': {
		pattern: /(?:#!)?"(?:[^"\r\n]|"")*"(?!")/,
		greedy: true
	},
	'constant': [
		/\bDay\.(?:Friday|Monday|Saturday|Sunday|Thursday|Tuesday|Wednesday)\b/,
		/\bTraceLevel\.(?:Critical|Error|Information|Verbose|Warning)\b/,
		/\bOccurrence\.(?:All|First|Last)\b/,
		/\bOrder\.(?:Ascending|Descending)\b/,
		/\bRoundingMode\.(?:AwayFromZero|Down|ToEven|TowardZero|Up)\b/,
		/\bMissingField\.(?:Error|Ignore|UseNull)\b/,
		/\bQuoteStyle\.(?:Csv|None)\b/,
		/\bJoinKind\.(?:FullOuter|Inner|LeftAnti|LeftOuter|RightAnti|RightOuter)\b/,
		/\bGroupKind\.(?:Global|Local)\b/,
		/\bExtraValues\.(?:Error|Ignore|List)\b/,
		/\bJoinAlgorithm\.(?:Dynamic|LeftHash|LeftIndex|PairwiseHash|RightHash|RightIndex|SortMerge)\b/,
		/\bJoinSide\.(?:Left|Right)\b/,
		/\bPrecision\.(?:Decimal|Double)\b/,
		/\bRelativePosition\.From(?:End|Start)\b/,
		/\bTextEncoding\.(?:Ascii|BigEndianUnicode|Unicode|Utf16|Utf8|Windows)\b/,
		/\b(?:Any|Binary|Date|DateTime|DateTimeZone|Duration|Function|Int16|Int32|Int64|Int8|List|Logical|None|Number|Record|Table|Text|Time)\.Type\b/,
		/\bnull\b/
	],
	'boolean': /\b(?:false|true)\b/,
	'keyword': /\b(?:and|as|each|else|error|if|in|is|let|meta|not|nullable|optional|or|otherwise|section|shared|then|try|type)\b|#(?:binary|date|datetime|datetimezone|duration|infinity|nan|sections|shared|table|time)\b/,
	'function': {
		pattern: /(^|[^#\w.])[a-z_][\w.]*(?=\s*\()/i,
		lookbehind: true
	},
	'data-type': {
		pattern: /\b(?:any|anynonnull|binary|date|datetime|datetimezone|duration|function|list|logical|none|number|record|table|text|time)\b/,
		alias: 'class-name'
	},
	'number': {
		pattern: /\b0x[\da-f]+\b|(?:[+-]?(?:\b\d+\.)?\b\d+|[+-]\.\d+|(^|[^.])\B\.\d+)(?:e[+-]?\d+)?\b/i,
		lookbehind: true
	},
	'operator': /[-+*\/&?@^]|<(?:=>?|>)?|>=?|=>?|\.\.\.?/,
	'punctuation': /[,;\[\](){}]/
};

Prism.languages.pq = Prism.languages['powerquery'];
Prism.languages.mscript = Prism.languages['powerquery'];

(function (Prism) {

	var powershell = Prism.languages.powershell = {
		'comment': [
			{
				pattern: /(^|[^`])<#[\s\S]*?#>/,
				lookbehind: true
			},
			{
				pattern: /(^|[^`])#.*/,
				lookbehind: true
			}
		],
		'string': [
			{
				pattern: /"(?:`[\s\S]|[^`"])*"/,
				greedy: true,
				inside: null // see below
			},
			{
				pattern: /'(?:[^']|'')*'/,
				greedy: true
			}
		],
		// Matches name spaces as well as casts, attribute decorators. Force starting with letter to avoid matching array indices
		// Supports two levels of nested brackets (e.g. `[OutputType([System.Collections.Generic.List[int]])]`)
		'namespace': /\[[a-z](?:\[(?:\[[^\]]*\]|[^\[\]])*\]|[^\[\]])*\]/i,
		'boolean': /\$(?:false|true)\b/i,
		'variable': /\$\w+\b/,
		// Cmdlets and aliases. Aliases should come last, otherwise "write" gets preferred over "write-host" for example
		// Get-Command | ?{ $_.ModuleName -match "Microsoft.PowerShell.(Util|Core|Management)" }
		// Get-Alias | ?{ $_.ReferencedCommand.Module.Name -match "Microsoft.PowerShell.(Util|Core|Management)" }
		'function': [
			/\b(?:Add|Approve|Assert|Backup|Block|Checkpoint|Clear|Close|Compare|Complete|Compress|Confirm|Connect|Convert|ConvertFrom|ConvertTo|Copy|Debug|Deny|Disable|Disconnect|Dismount|Edit|Enable|Enter|Exit|Expand|Export|Find|ForEach|Format|Get|Grant|Group|Hide|Import|Initialize|Install|Invoke|Join|Limit|Lock|Measure|Merge|Move|New|Open|Optimize|Out|Ping|Pop|Protect|Publish|Push|Read|Receive|Redo|Register|Remove|Rename|Repair|Request|Reset|Resize|Resolve|Restart|Restore|Resume|Revoke|Save|Search|Select|Send|Set|Show|Skip|Sort|Split|Start|Step|Stop|Submit|Suspend|Switch|Sync|Tee|Test|Trace|Unblock|Undo|Uninstall|Unlock|Unprotect|Unpublish|Unregister|Update|Use|Wait|Watch|Where|Write)-[a-z]+\b/i,
			/\b(?:ac|cat|chdir|clc|cli|clp|clv|compare|copy|cp|cpi|cpp|cvpa|dbp|del|diff|dir|ebp|echo|epal|epcsv|epsn|erase|fc|fl|ft|fw|gal|gbp|gc|gci|gcs|gdr|gi|gl|gm|gp|gps|group|gsv|gu|gv|gwmi|iex|ii|ipal|ipcsv|ipsn|irm|iwmi|iwr|kill|lp|ls|measure|mi|mount|move|mp|mv|nal|ndr|ni|nv|ogv|popd|ps|pushd|pwd|rbp|rd|rdr|ren|ri|rm|rmdir|rni|rnp|rp|rv|rvpa|rwmi|sal|saps|sasv|sbp|sc|select|set|shcm|si|sl|sleep|sls|sort|sp|spps|spsv|start|sv|swmi|tee|trcm|type|write)\b/i
		],
		// per http://technet.microsoft.com/en-us/library/hh847744.aspx
		'keyword': /\b(?:Begin|Break|Catch|Class|Continue|Data|Define|Do|DynamicParam|Else|ElseIf|End|Exit|Filter|Finally|For|ForEach|From|Function|If|InlineScript|Parallel|Param|Process|Return|Sequence|Switch|Throw|Trap|Try|Until|Using|Var|While|Workflow)\b/i,
		'operator': {
			pattern: /(^|\W)(?:!|-(?:b?(?:and|x?or)|as|(?:Not)?(?:Contains|In|Like|Match)|eq|ge|gt|is(?:Not)?|Join|le|lt|ne|not|Replace|sh[lr])\b|-[-=]?|\+[+=]?|[*\/%]=?)/i,
			lookbehind: true
		},
		'punctuation': /[|{}[\];(),.]/
	};

	// Variable interpolation inside strings, and nested expressions
	powershell.string[0].inside = {
		'function': {
			// Allow for one level of nesting
			pattern: /(^|[^`])\$\((?:\$\([^\r\n()]*\)|(?!\$\()[^\r\n)])*\)/,
			lookbehind: true,
			inside: powershell
		},
		'boolean': powershell.boolean,
		'variable': powershell.variable,
	};

}(Prism));

Prism.languages.processing = Prism.languages.extend('clike', {
	'keyword': /\b(?:break|case|catch|class|continue|default|else|extends|final|for|if|implements|import|new|null|private|public|return|static|super|switch|this|try|void|while)\b/,
	// Spaces are allowed between function name and parenthesis
	'function': /\b\w+(?=\s*\()/,
	'operator': /<[<=]?|>[>=]?|&&?|\|\|?|[%?]|[!=+\-*\/]=?/
});

Prism.languages.insertBefore('processing', 'number', {
	// Special case: XML is a type
	'constant': /\b(?!XML\b)[A-Z][A-Z\d_]+\b/,
	'type': {
		pattern: /\b(?:boolean|byte|char|color|double|float|int|[A-Z]\w*)\b/,
		alias: 'class-name'
	}
});

Prism.languages.prolog = {
	// Syntax depends on the implementation
	'comment': {
		pattern: /\/\*[\s\S]*?\*\/|%.*/,
		greedy: true
	},
	// Depending on the implementation, strings may allow escaped newlines and quote-escape
	'string': {
		pattern: /(["'])(?:\1\1|\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1(?!\1)/,
		greedy: true
	},
	'builtin': /\b(?:fx|fy|xf[xy]?|yfx?)\b/,
	// FIXME: Should we list all null-ary predicates (not followed by a parenthesis) like halt, trace, etc.?
	'function': /\b[a-z]\w*(?:(?=\()|\/\d+)/,
	'number': /\b\d+(?:\.\d*)?/,
	// Custom operators are allowed
	'operator': /[:\\=><\-?*@\/;+^|!$.]+|\b(?:is|mod|not|xor)\b/,
	'punctuation': /[(){}\[\],]/
};

Prism.languages.properties = {
	'comment': /^[ \t]*[#!].*$/m,
	'value': {
		pattern: /(^[ \t]*(?:\\(?:\r\n|[\s\S])|[^\\\s:=])+(?: *[=:] *(?! )| ))(?:\\(?:\r\n|[\s\S])|[^\\\r\n])+/m,
		lookbehind: true,
		alias: 'attr-value'
	},
	'key': {
		pattern: /^[ \t]*(?:\\(?:\r\n|[\s\S])|[^\\\s:=])+(?= *[=:]| )/m,
		alias: 'attr-name'
	},
	'punctuation': /[=:]/
};

(function (Prism) {

	var builtinTypes = /\b(?:bool|bytes|double|s?fixed(?:32|64)|float|[su]?int(?:32|64)|string)\b/;

	Prism.languages.protobuf = Prism.languages.extend('clike', {
		'class-name': [
			{
				pattern: /(\b(?:enum|extend|message|service)\s+)[A-Za-z_]\w*(?=\s*\{)/,
				lookbehind: true
			},
			{
				pattern: /(\b(?:rpc\s+\w+|returns)\s*\(\s*(?:stream\s+)?)\.?[A-Za-z_]\w*(?:\.[A-Za-z_]\w*)*(?=\s*\))/,
				lookbehind: true
			}
		],
		'keyword': /\b(?:enum|extend|extensions|import|message|oneof|option|optional|package|public|repeated|required|reserved|returns|rpc(?=\s+\w)|service|stream|syntax|to)\b(?!\s*=\s*\d)/,
		'function': /\b[a-z_]\w*(?=\s*\()/i
	});

	Prism.languages.insertBefore('protobuf', 'operator', {
		'map': {
			pattern: /\bmap<\s*[\w.]+\s*,\s*[\w.]+\s*>(?=\s+[a-z_]\w*\s*[=;])/i,
			alias: 'class-name',
			inside: {
				'punctuation': /[<>.,]/,
				'builtin': builtinTypes
			}
		},
		'builtin': builtinTypes,
		'positional-class-name': {
			pattern: /(?:\b|\B\.)[a-z_]\w*(?:\.[a-z_]\w*)*(?=\s+[a-z_]\w*\s*[=;])/i,
			alias: 'class-name',
			inside: {
				'punctuation': /\./
			}
		},
		'annotation': {
			pattern: /(\[\s*)[a-z_]\w*(?=\s*=)/i,
			lookbehind: true
		}
	});

}(Prism));

(function (Prism) {
	// TODO:
	// - Add CSS highlighting inside <style> tags
	// - Add support for multi-line code blocks
	// - Add support for interpolation #{} and !{}
	// - Add support for tag interpolation #[]
	// - Add explicit support for plain text using |
	// - Add support for markup embedded in plain text

	Prism.languages.pug = {

		// Multiline stuff should appear before the rest

		// This handles both single-line and multi-line comments
		'comment': {
			pattern: /(^([\t ]*))\/\/.*(?:(?:\r?\n|\r)\2[\t ].+)*/m,
			lookbehind: true
		},

		// All the tag-related part is in lookbehind
		// so that it can be highlighted by the "tag" pattern
		'multiline-script': {
			pattern: /(^([\t ]*)script\b.*\.[\t ]*)(?:(?:\r?\n|\r(?!\n))(?:\2[\t ].+|\s*?(?=\r?\n|\r)))+/m,
			lookbehind: true,
			inside: Prism.languages.javascript
		},

		// See at the end of the file for known filters
		'filter': {
			pattern: /(^([\t ]*)):.+(?:(?:\r?\n|\r(?!\n))(?:\2[\t ].+|\s*?(?=\r?\n|\r)))+/m,
			lookbehind: true,
			inside: {
				'filter-name': {
					pattern: /^:[\w-]+/,
					alias: 'variable'
				},
				'text': /\S[\s\S]*/,
			}
		},

		'multiline-plain-text': {
			pattern: /(^([\t ]*)[\w\-#.]+\.[\t ]*)(?:(?:\r?\n|\r(?!\n))(?:\2[\t ].+|\s*?(?=\r?\n|\r)))+/m,
			lookbehind: true
		},
		'markup': {
			pattern: /(^[\t ]*)<.+/m,
			lookbehind: true,
			inside: Prism.languages.markup
		},
		'doctype': {
			pattern: /((?:^|\n)[\t ]*)doctype(?: .+)?/,
			lookbehind: true
		},

		// This handle all conditional and loop keywords
		'flow-control': {
			pattern: /(^[\t ]*)(?:case|default|each|else|if|unless|when|while)\b(?: .+)?/m,
			lookbehind: true,
			inside: {
				'each': {
					pattern: /^each .+? in\b/,
					inside: {
						'keyword': /\b(?:each|in)\b/,
						'punctuation': /,/
					}
				},
				'branch': {
					pattern: /^(?:case|default|else|if|unless|when|while)\b/,
					alias: 'keyword'
				},
				rest: Prism.languages.javascript
			}
		},
		'keyword': {
			pattern: /(^[\t ]*)(?:append|block|extends|include|prepend)\b.+/m,
			lookbehind: true
		},
		'mixin': [
			// Declaration
			{
				pattern: /(^[\t ]*)mixin .+/m,
				lookbehind: true,
				inside: {
					'keyword': /^mixin/,
					'function': /\w+(?=\s*\(|\s*$)/,
					'punctuation': /[(),.]/
				}
			},
			// Usage
			{
				pattern: /(^[\t ]*)\+.+/m,
				lookbehind: true,
				inside: {
					'name': {
						pattern: /^\+\w+/,
						alias: 'function'
					},
					rest: Prism.languages.javascript
				}
			}
		],
		'script': {
			pattern: /(^[\t ]*script(?:(?:&[^(]+)?\([^)]+\))*[\t ]).+/m,
			lookbehind: true,
			inside: Prism.languages.javascript
		},

		'plain-text': {
			pattern: /(^[\t ]*(?!-)[\w\-#.]*[\w\-](?:(?:&[^(]+)?\([^)]+\))*\/?[\t ]).+/m,
			lookbehind: true
		},
		'tag': {
			pattern: /(^[\t ]*)(?!-)[\w\-#.]*[\w\-](?:(?:&[^(]+)?\([^)]+\))*\/?:?/m,
			lookbehind: true,
			inside: {
				'attributes': [
					{
						pattern: /&[^(]+\([^)]+\)/,
						inside: Prism.languages.javascript
					},
					{
						pattern: /\([^)]+\)/,
						inside: {
							'attr-value': {
								pattern: /(=\s*(?!\s))(?:\{[^}]*\}|[^,)\r\n]+)/,
								lookbehind: true,
								inside: Prism.languages.javascript
							},
							'attr-name': /[\w-]+(?=\s*!?=|\s*[,)])/,
							'punctuation': /[!=(),]+/
						}
					}
				],
				'punctuation': /:/,
				'attr-id': /#[\w\-]+/,
				'attr-class': /\.[\w\-]+/
			}
		},
		'code': [
			{
				pattern: /(^[\t ]*(?:-|!?=)).+/m,
				lookbehind: true,
				inside: Prism.languages.javascript
			}
		],
		'punctuation': /[.\-!=|]+/
	};

	var filter_pattern = /(^([\t ]*)):<filter_name>(?:(?:\r?\n|\r(?!\n))(?:\2[\t ].+|\s*?(?=\r?\n|\r)))+/.source;

	// Non exhaustive list of available filters and associated languages
	var filters = [
		{ filter: 'atpl', language: 'twig' },
		{ filter: 'coffee', language: 'coffeescript' },
		'ejs',
		'handlebars',
		'less',
		'livescript',
		'markdown',
		{ filter: 'sass', language: 'scss' },
		'stylus'
	];
	var all_filters = {};
	for (var i = 0, l = filters.length; i < l; i++) {
		var filter = filters[i];
		filter = typeof filter === 'string' ? { filter: filter, language: filter } : filter;
		if (Prism.languages[filter.language]) {
			all_filters['filter-' + filter.filter] = {
				pattern: RegExp(filter_pattern.replace('<filter_name>', function () { return filter.filter; }), 'm'),
				lookbehind: true,
				inside: {
					'filter-name': {
						pattern: /^:[\w-]+/,
						alias: 'variable'
					},
					'text': {
						pattern: /\S[\s\S]*/,
						alias: [filter.language, 'language-' + filter.language],
						inside: Prism.languages[filter.language]
					}
				}
			};
		}
	}

	Prism.languages.insertBefore('pug', 'filter', all_filters);

}(Prism));

(function (Prism) {
	Prism.languages.puppet = {
		'heredoc': [
			// Matches the content of a quoted heredoc string (subject to interpolation)
			{
				pattern: /(@\("([^"\r\n\/):]+)"(?:\/[nrts$uL]*)?\).*(?:\r?\n|\r))(?:.*(?:\r?\n|\r(?!\n)))*?[ \t]*(?:\|[ \t]*)?(?:-[ \t]*)?\2/,
				lookbehind: true,
				alias: 'string',
				inside: {
					// Matches the end tag
					'punctuation': /(?=\S).*\S(?= *$)/
					// See interpolation below
				}
			},
			// Matches the content of an unquoted heredoc string (no interpolation)
			{
				pattern: /(@\(([^"\r\n\/):]+)(?:\/[nrts$uL]*)?\).*(?:\r?\n|\r))(?:.*(?:\r?\n|\r(?!\n)))*?[ \t]*(?:\|[ \t]*)?(?:-[ \t]*)?\2/,
				lookbehind: true,
				greedy: true,
				alias: 'string',
				inside: {
					// Matches the end tag
					'punctuation': /(?=\S).*\S(?= *$)/
				}
			},
			// Matches the start tag of heredoc strings
			{
				pattern: /@\("?(?:[^"\r\n\/):]+)"?(?:\/[nrts$uL]*)?\)/,
				alias: 'string',
				inside: {
					'punctuation': {
						pattern: /(\().+?(?=\))/,
						lookbehind: true
					}
				}
			}
		],
		'multiline-comment': {
			pattern: /(^|[^\\])\/\*[\s\S]*?\*\//,
			lookbehind: true,
			greedy: true,
			alias: 'comment'
		},
		'regex': {
			// Must be prefixed with the keyword "node" or a non-word char
			pattern: /((?:\bnode\s+|[~=\(\[\{,]\s*|[=+]>\s*|^\s*))\/(?:[^\/\\]|\\[\s\S])+\/(?:[imx]+\b|\B)/,
			lookbehind: true,
			greedy: true,
			inside: {
				// Extended regexes must have the x flag. They can contain single-line comments.
				'extended-regex': {
					pattern: /^\/(?:[^\/\\]|\\[\s\S])+\/[im]*x[im]*$/,
					inside: {
						'comment': /#.*/
					}
				}
			}
		},
		'comment': {
			pattern: /(^|[^\\])#.*/,
			lookbehind: true,
			greedy: true,
		},
		'string': {
			// Allow for one nested level of double quotes inside interpolation
			pattern: /(["'])(?:\$\{(?:[^'"}]|(["'])(?:(?!\2)[^\\]|\\[\s\S])*\2)+\}|\$(?!\{)|(?!\1)[^\\$]|\\[\s\S])*\1/,
			greedy: true,
			inside: {
				'double-quoted': {
					pattern: /^"[\s\S]*"$/,
					inside: {
						// See interpolation below
					}
				}
			}
		},
		'variable': {
			pattern: /\$(?:::)?\w+(?:::\w+)*/,
			inside: {
				'punctuation': /::/
			}
		},
		'attr-name': /(?:\b\w+|\*)(?=\s*=>)/,
		'function': [
			{
				pattern: /(\.)(?!\d)\w+/,
				lookbehind: true
			},
			/\b(?:contain|debug|err|fail|include|info|notice|realize|require|tag|warning)\b|\b(?!\d)\w+(?=\()/
		],
		'number': /\b(?:0x[a-f\d]+|\d+(?:\.\d+)?(?:e-?\d+)?)\b/i,
		'boolean': /\b(?:false|true)\b/,
		// Includes words reserved for future use
		'keyword': /\b(?:application|attr|case|class|consumes|default|define|else|elsif|function|if|import|inherits|node|private|produces|type|undef|unless)\b/,
		'datatype': {
			pattern: /\b(?:Any|Array|Boolean|Callable|Catalogentry|Class|Collection|Data|Default|Enum|Float|Hash|Integer|NotUndef|Numeric|Optional|Pattern|Regexp|Resource|Runtime|Scalar|String|Struct|Tuple|Type|Undef|Variant)\b/,
			alias: 'symbol'
		},
		'operator': /=[=~>]?|![=~]?|<(?:<\|?|[=~|-])?|>[>=]?|->?|~>|\|>?>?|[*\/%+?]|\b(?:and|in|or)\b/,
		'punctuation': /[\[\]{}().,;]|:+/
	};

	var interpolation = [
		{
			// Allow for one nested level of braces inside interpolation
			pattern: /(^|[^\\])\$\{(?:[^'"{}]|\{[^}]*\}|(["'])(?:(?!\2)[^\\]|\\[\s\S])*\2)+\}/,
			lookbehind: true,
			inside: {
				'short-variable': {
					// Negative look-ahead prevent wrong highlighting of functions
					pattern: /(^\$\{)(?!\w+\()(?:::)?\w+(?:::\w+)*/,
					lookbehind: true,
					alias: 'variable',
					inside: {
						'punctuation': /::/
					}
				},
				'delimiter': {
					pattern: /^\$/,
					alias: 'variable'
				},
				rest: Prism.languages.puppet
			}
		},
		{
			pattern: /(^|[^\\])\$(?:::)?\w+(?:::\w+)*/,
			lookbehind: true,
			alias: 'variable',
			inside: {
				'punctuation': /::/
			}
		}
	];
	Prism.languages.puppet['heredoc'][0].inside.interpolation = interpolation;
	Prism.languages.puppet['string'].inside['double-quoted'].inside.interpolation = interpolation;
}(Prism));

(function (Prism) {
	// https://agraef.github.io/pure-docs/pure.html#lexical-matters

	Prism.languages.pure = {
		'comment': [
			{
				pattern: /(^|[^\\])\/\*[\s\S]*?\*\//,
				lookbehind: true
			},
			{
				pattern: /(^|[^\\:])\/\/.*/,
				lookbehind: true
			},
			/#!.+/
		],
		'inline-lang': {
			pattern: /%<[\s\S]+?%>/,
			greedy: true,
			inside: {
				'lang': {
					pattern: /(^%< *)-\*-.+?-\*-/,
					lookbehind: true,
					alias: 'comment'
				},
				'delimiter': {
					pattern: /^%<.*|%>$/,
					alias: 'punctuation'
				}
			}
		},
		'string': {
			pattern: /"(?:\\.|[^"\\\r\n])*"/,
			greedy: true
		},
		'number': {
			// The look-behind prevents wrong highlighting of the .. operator
			pattern: /((?:\.\.)?)(?:\b(?:inf|nan)\b|\b0x[\da-f]+|(?:\b(?:0b)?\d+(?:\.\d+)?|\B\.\d+)(?:e[+-]?\d+)?L?)/i,
			lookbehind: true
		},
		'keyword': /\b(?:NULL|ans|break|bt|case|catch|cd|clear|const|def|del|dump|else|end|exit|extern|false|force|help|if|infix[lr]?|interface|let|ls|mem|namespace|nonfix|of|otherwise|outfix|override|postfix|prefix|private|public|pwd|quit|run|save|show|stats|then|throw|trace|true|type|underride|using|when|with)\b/,
		'function': /\b(?:abs|add_(?:addr|constdef|(?:fundef|interface|macdef|typedef)(?:_at)?|vardef)|all|any|applp?|arity|bigintp?|blob(?:_crc|_size|p)?|boolp?|byte_c?string(?:_pointer)?|byte_(?:matrix|pointer)|calloc|cat|catmap|ceil|char[ps]?|check_ptrtag|chr|clear_sentry|clearsym|closurep?|cmatrixp?|cols?|colcat(?:map)?|colmap|colrev|colvector(?:p|seq)?|complex(?:_float_(?:matrix|pointer)|_matrix(?:_view)?|_pointer|p)?|conj|cookedp?|cst|cstring(?:_(?:dup|list|vector))?|curry3?|cyclen?|del_(?:constdef|fundef|interface|macdef|typedef|vardef)|delete|diag(?:mat)?|dim|dmatrixp?|do|double(?:_matrix(?:_view)?|_pointer|p)?|dowith3?|drop|dropwhile|eval(?:cmd)?|exactp|filter|fix|fixity|flip|float(?:_matrix|_pointer)|floor|fold[lr]1?|frac|free|funp?|functionp?|gcd|get(?:_(?:byte|constdef|double|float|fundef|int(?:64)?|interface(?:_typedef)?|long|macdef|pointer|ptrtag|sentry|short|string|typedef|vardef))?|globsym|hash|head|id|im|imatrixp?|index|inexactp|infp|init|insert|int(?:_matrix(?:_view)?|_pointer|p)?|int64_(?:matrix|pointer)|integerp?|iteraten?|iterwhile|join|keys?|lambdap?|last(?:err(?:pos)?)?|lcd|list[2p]?|listmap|make_ptrtag|malloc|map|matcat|matrixp?|max|member|min|nanp|nargs|nmatrixp?|null|numberp?|ord|pack(?:ed)?|pointer(?:_cast|_tag|_type|p)?|pow|pred|ptrtag|put(?:_(?:byte|double|float|int(?:64)?|long|pointer|short|string))?|rationalp?|re|realp?|realloc|recordp?|redim|reduce(?:_with)?|refp?|repeatn?|reverse|rlistp?|round|rows?|rowcat(?:map)?|rowmap|rowrev|rowvector(?:p|seq)?|same|scan[lr]1?|sentry|sgn|short_(?:matrix|pointer)|slice|smatrixp?|sort|split|str|strcat|stream|stride|string(?:_(?:dup|list|vector)|p)?|subdiag(?:mat)?|submat|subseq2?|substr|succ|supdiag(?:mat)?|symbolp?|tail|take|takewhile|thunkp?|transpose|trunc|tuplep?|typep|ubyte|uint(?:64)?|ulong|uncurry3?|unref|unzip3?|update|ushort|vals?|varp?|vector(?:p|seq)?|void|zip3?|zipwith3?)\b/,
		'special': {
			pattern: /\b__[a-z]+__\b/i,
			alias: 'builtin'
		},
		// Any combination of operator chars can be an operator
		// eslint-disable-next-line no-misleading-character-class
		'operator': /(?:[!"#$%&'*+,\-.\/:<=>?@\\^`|~\u00a1-\u00bf\u00d7-\u00f7\u20d0-\u2bff]|\b_+\b)+|\b(?:and|div|mod|not|or)\b/,
		// FIXME: How can we prevent | and , to be highlighted as operator when they are used alone?
		'punctuation': /[(){}\[\];,|]/
	};

	var inlineLanguages = [
		'c',
		{ lang: 'c++', alias: 'cpp' },
		'fortran'
	];
	var inlineLanguageRe = /%< *-\*- *<lang>\d* *-\*-[\s\S]+?%>/.source;

	inlineLanguages.forEach(function (lang) {
		var alias = lang;
		if (typeof lang !== 'string') {
			alias = lang.alias;
			lang = lang.lang;
		}
		if (Prism.languages[alias]) {
			var o = {};
			o['inline-lang-' + alias] = {
				pattern: RegExp(inlineLanguageRe.replace('<lang>', lang.replace(/([.+*?\/\\(){}\[\]])/g, '\\$1')), 'i'),
				inside: Prism.util.clone(Prism.languages.pure['inline-lang'].inside)
			};
			o['inline-lang-' + alias].inside.rest = Prism.util.clone(Prism.languages[alias]);
			Prism.languages.insertBefore('pure', 'inline-lang', o);
		}
	});

	// C is the default inline language
	if (Prism.languages.c) {
		Prism.languages.pure['inline-lang'].inside.rest = Prism.util.clone(Prism.languages.c);
	}

}(Prism));

/*
Original Code by Bas Groothedde
!!MANY THANKS!! I never would have made this, regex and me will never be best friends ;)
==> https://codepen.io/ImagineProgramming/details/JYydBy/
slightly changed to pass all tests
*/


// PureBasic support, steal stuff from ansi-c
Prism.languages.purebasic = Prism.languages.extend('clike', {
	'comment': /;.*/,
	'keyword': /\b(?:align|and|as|break|calldebugger|case|compilercase|compilerdefault|compilerelse|compilerelseif|compilerendif|compilerendselect|compilererror|compilerif|compilerselect|continue|data|datasection|debug|debuglevel|declare|declarec|declarecdll|declaredll|declaremodule|default|define|dim|disableasm|disabledebugger|disableexplicit|else|elseif|enableasm|enabledebugger|enableexplicit|end|enddatasection|enddeclaremodule|endenumeration|endif|endimport|endinterface|endmacro|endmodule|endprocedure|endselect|endstructure|endstructureunion|endwith|enumeration|extends|fakereturn|for|foreach|forever|global|gosub|goto|if|import|importc|includebinary|includefile|includepath|interface|macro|module|newlist|newmap|next|not|or|procedure|procedurec|procedurecdll|proceduredll|procedurereturn|protected|prototype|prototypec|read|redim|repeat|restore|return|runtime|select|shared|static|step|structure|structureunion|swap|threaded|to|until|wend|while|with|xincludefile|xor)\b/i,
	'function': /\b\w+(?:\.\w+)?\s*(?=\()/,
	'number': /(?:\$[\da-f]+|\b-?(?:\d+(?:\.\d+)?|\.\d+)(?:e[+-]?\d+)?)\b/i,
	'operator': /(?:@\*?|\?|\*)\w+\$?|-[>-]?|\+\+?|!=?|<<?=?|>>?=?|==?|&&?|\|?\||[~^%?*/@]/
});

Prism.languages.insertBefore('purebasic', 'keyword', {
	'tag': /#\w+\$?/,
	'asm': {
		pattern: /(^[\t ]*)!.*/m,
		lookbehind: true,
		alias: 'tag',
		inside: {
			'comment': /;.*/,
			'string': {
				pattern: /(["'`])(?:\\.|(?!\1)[^\\\r\n])*\1/,
				greedy: true
			},
			// Anonymous label references, i.e.: jmp @b
			'label-reference-anonymous': {
				pattern: /(!\s*j[a-z]+\s+)@[fb]/i,
				lookbehind: true,
				alias: 'fasm-label'
			},
			// Named label reference, i.e.: jne label1
			'label-reference-addressed': {
				pattern: /(!\s*j[a-z]+\s+)[A-Z._?$@][\w.?$@~#]*/i,
				lookbehind: true,
				alias: 'fasm-label'
			},
			'keyword': [
				/\b(?:extern|global)\b[^;\r\n]*/i,
				/\b(?:CPU|DEFAULT|FLOAT)\b.*/
			],
			'function': {
				pattern: /^([\t ]*!\s*)[\da-z]+(?=\s|$)/im,
				lookbehind: true
			},
			'function-inline': {
				pattern: /(:\s*)[\da-z]+(?=\s)/i,
				lookbehind: true,
				alias: 'function'
			},
			'label': {
				pattern: /^([\t ]*!\s*)[A-Za-z._?$@][\w.?$@~#]*(?=:)/m,
				lookbehind: true,
				alias: 'fasm-label'
			},
			'register': /\b(?:st\d|[xyz]mm\d\d?|[cdt]r\d|r\d\d?[bwd]?|[er]?[abcd]x|[abcd][hl]|[er]?(?:bp|di|si|sp)|[cdefgs]s|mm\d+)\b/i,
			'number': /(?:\b|-|(?=\$))(?:0[hx](?:[\da-f]*\.)?[\da-f]+(?:p[+-]?\d+)?|\d[\da-f]+[hx]|\$\d[\da-f]*|0[oq][0-7]+|[0-7]+[oq]|0[by][01]+|[01]+[by]|0[dt]\d+|(?:\d+(?:\.\d+)?|\.\d+)(?:\.?e[+-]?\d+)?[dt]?)\b/i,
			'operator': /[\[\]*+\-/%<>=&|$!,.:]/
		}
	}
});

delete Prism.languages.purebasic['class-name'];
delete Prism.languages.purebasic['boolean'];

Prism.languages.pbfasm = Prism.languages['purebasic'];

Prism.languages.purescript = Prism.languages.extend('haskell', {
	'keyword': /\b(?:ado|case|class|data|derive|do|else|forall|if|in|infixl|infixr|instance|let|module|newtype|of|primitive|then|type|where)\b|∀/,

	'import-statement': {
		// The imported or hidden names are not included in this import
		// statement. This is because we want to highlight those exactly like
		// we do for the names in the program.
		pattern: /(^[\t ]*)import\s+[A-Z][\w']*(?:\.[A-Z][\w']*)*(?:\s+as\s+[A-Z][\w']*(?:\.[A-Z][\w']*)*)?(?:\s+hiding\b)?/m,
		lookbehind: true,
		inside: {
			'keyword': /\b(?:as|hiding|import)\b/,
			'punctuation': /\./
		}
	},

	// These are builtin functions only. Constructors are highlighted later as a constant.
	'builtin': /\b(?:absurd|add|ap|append|apply|between|bind|bottom|clamp|compare|comparing|compose|conj|const|degree|discard|disj|div|eq|flap|flip|gcd|identity|ifM|join|lcm|liftA1|liftM1|map|max|mempty|min|mod|mul|negate|not|notEq|one|otherwise|recip|show|sub|top|unit|unless|unlessM|void|when|whenM|zero)\b/,

	'operator': [
		// Infix operators
		Prism.languages.haskell.operator[0],
		// ASCII operators
		Prism.languages.haskell.operator[2],
		// All UTF16 Unicode operator symbols
		// This regex is equivalent to /(?=[\x80-\uFFFF])[\p{gc=Math_Symbol}\p{gc=Currency_Symbol}\p{Modifier_Symbol}\p{Other_Symbol}]/u
		// See https://github.com/PrismJS/prism/issues/3006 for more details.
		/[\xa2-\xa6\xa8\xa9\xac\xae-\xb1\xb4\xb8\xd7\xf7\u02c2-\u02c5\u02d2-\u02df\u02e5-\u02eb\u02ed\u02ef-\u02ff\u0375\u0384\u0385\u03f6\u0482\u058d-\u058f\u0606-\u0608\u060b\u060e\u060f\u06de\u06e9\u06fd\u06fe\u07f6\u07fe\u07ff\u09f2\u09f3\u09fa\u09fb\u0af1\u0b70\u0bf3-\u0bfa\u0c7f\u0d4f\u0d79\u0e3f\u0f01-\u0f03\u0f13\u0f15-\u0f17\u0f1a-\u0f1f\u0f34\u0f36\u0f38\u0fbe-\u0fc5\u0fc7-\u0fcc\u0fce\u0fcf\u0fd5-\u0fd8\u109e\u109f\u1390-\u1399\u166d\u17db\u1940\u19de-\u19ff\u1b61-\u1b6a\u1b74-\u1b7c\u1fbd\u1fbf-\u1fc1\u1fcd-\u1fcf\u1fdd-\u1fdf\u1fed-\u1fef\u1ffd\u1ffe\u2044\u2052\u207a-\u207c\u208a-\u208c\u20a0-\u20bf\u2100\u2101\u2103-\u2106\u2108\u2109\u2114\u2116-\u2118\u211e-\u2123\u2125\u2127\u2129\u212e\u213a\u213b\u2140-\u2144\u214a-\u214d\u214f\u218a\u218b\u2190-\u2307\u230c-\u2328\u232b-\u2426\u2440-\u244a\u249c-\u24e9\u2500-\u2767\u2794-\u27c4\u27c7-\u27e5\u27f0-\u2982\u2999-\u29d7\u29dc-\u29fb\u29fe-\u2b73\u2b76-\u2b95\u2b97-\u2bff\u2ce5-\u2cea\u2e50\u2e51\u2e80-\u2e99\u2e9b-\u2ef3\u2f00-\u2fd5\u2ff0-\u2ffb\u3004\u3012\u3013\u3020\u3036\u3037\u303e\u303f\u309b\u309c\u3190\u3191\u3196-\u319f\u31c0-\u31e3\u3200-\u321e\u322a-\u3247\u3250\u3260-\u327f\u328a-\u32b0\u32c0-\u33ff\u4dc0-\u4dff\ua490-\ua4c6\ua700-\ua716\ua720\ua721\ua789\ua78a\ua828-\ua82b\ua836-\ua839\uaa77-\uaa79\uab5b\uab6a\uab6b\ufb29\ufbb2-\ufbc1\ufdfc\ufdfd\ufe62\ufe64-\ufe66\ufe69\uff04\uff0b\uff1c-\uff1e\uff3e\uff40\uff5c\uff5e\uffe0-\uffe6\uffe8-\uffee\ufffc\ufffd]/
	]
});

Prism.languages.purs = Prism.languages.purescript;

Prism.languages.python = {
	'comment': {
		pattern: /(^|[^\\])#.*/,
		lookbehind: true,
		greedy: true
	},
	'string-interpolation': {
		pattern: /(?:f|fr|rf)(?:("""|''')[\s\S]*?\1|("|')(?:\\.|(?!\2)[^\\\r\n])*\2)/i,
		greedy: true,
		inside: {
			'interpolation': {
				// "{" <expression> <optional "!s", "!r", or "!a"> <optional ":" format specifier> "}"
				pattern: /((?:^|[^{])(?:\{\{)*)\{(?!\{)(?:[^{}]|\{(?!\{)(?:[^{}]|\{(?!\{)(?:[^{}])+\})+\})+\}/,
				lookbehind: true,
				inside: {
					'format-spec': {
						pattern: /(:)[^:(){}]+(?=\}$)/,
						lookbehind: true
					},
					'conversion-option': {
						pattern: /![sra](?=[:}]$)/,
						alias: 'punctuation'
					},
					rest: null
				}
			},
			'string': /[\s\S]+/
		}
	},
	'triple-quoted-string': {
		pattern: /(?:[rub]|br|rb)?("""|''')[\s\S]*?\1/i,
		greedy: true,
		alias: 'string'
	},
	'string': {
		pattern: /(?:[rub]|br|rb)?("|')(?:\\.|(?!\1)[^\\\r\n])*\1/i,
		greedy: true
	},
	'function': {
		pattern: /((?:^|\s)def[ \t]+)[a-zA-Z_]\w*(?=\s*\()/g,
		lookbehind: true
	},
	'class-name': {
		pattern: /(\bclass\s+)\w+/i,
		lookbehind: true
	},
	'decorator': {
		pattern: /(^[\t ]*)@\w+(?:\.\w+)*/m,
		lookbehind: true,
		alias: ['annotation', 'punctuation'],
		inside: {
			'punctuation': /\./
		}
	},
	'keyword': /\b(?:_(?=\s*:)|and|as|assert|async|await|break|case|class|continue|def|del|elif|else|except|exec|finally|for|from|global|if|import|in|is|lambda|match|nonlocal|not|or|pass|print|raise|return|try|while|with|yield)\b/,
	'builtin': /\b(?:__import__|abs|all|any|apply|ascii|basestring|bin|bool|buffer|bytearray|bytes|callable|chr|classmethod|cmp|coerce|compile|complex|delattr|dict|dir|divmod|enumerate|eval|execfile|file|filter|float|format|frozenset|getattr|globals|hasattr|hash|help|hex|id|input|int|intern|isinstance|issubclass|iter|len|list|locals|long|map|max|memoryview|min|next|object|oct|open|ord|pow|property|range|raw_input|reduce|reload|repr|reversed|round|set|setattr|slice|sorted|staticmethod|str|sum|super|tuple|type|unichr|unicode|vars|xrange|zip)\b/,
	'boolean': /\b(?:False|None|True)\b/,
	'number': /\b0(?:b(?:_?[01])+|o(?:_?[0-7])+|x(?:_?[a-f0-9])+)\b|(?:\b\d+(?:_\d+)*(?:\.(?:\d+(?:_\d+)*)?)?|\B\.\d+(?:_\d+)*)(?:e[+-]?\d+(?:_\d+)*)?j?(?!\w)/i,
	'operator': /[-+%=]=?|!=|:=|\*\*?=?|\/\/?=?|<[<=>]?|>[=>]?|[&|^~]/,
	'punctuation': /[{}[\];(),.:]/
};

Prism.languages.python['string-interpolation'].inside['interpolation'].inside.rest = Prism.languages.python;

Prism.languages.py = Prism.languages.python;

(function (Prism) {

	var jsString = /"(?:\\.|[^\\"\r\n])*"|'(?:\\.|[^\\'\r\n])*'/.source;
	var jsComment = /\/\/.*(?!.)|\/\*(?:[^*]|\*(?!\/))*\*\//.source;

	var jsExpr = /(?:[^\\()[\]{}"'/]|<string>|\/(?![*/])|<comment>|\(<expr>*\)|\[<expr>*\]|\{<expr>*\}|\\[\s\S])/
		.source.replace(/<string>/g, function () { return jsString; }).replace(/<comment>/g, function () { return jsComment; });

	// the pattern will blow up, so only a few iterations
	for (var i = 0; i < 2; i++) {
		jsExpr = jsExpr.replace(/<expr>/g, function () { return jsExpr; });
	}
	jsExpr = jsExpr.replace(/<expr>/g, '[^\\s\\S]');


	Prism.languages.qml = {
		'comment': {
			pattern: /\/\/.*|\/\*[\s\S]*?\*\//,
			greedy: true
		},
		'javascript-function': {
			pattern: RegExp(/((?:^|;)[ \t]*)function\s+(?!\s)[_$a-zA-Z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*\s*\(<js>*\)\s*\{<js>*\}/.source.replace(/<js>/g, function () { return jsExpr; }), 'm'),
			lookbehind: true,
			greedy: true,
			alias: 'language-javascript',
			inside: Prism.languages.javascript
		},
		'class-name': {
			pattern: /((?:^|[:;])[ \t]*)(?!\d)\w+(?=[ \t]*\{|[ \t]+on\b)/m,
			lookbehind: true
		},
		'property': [
			{
				pattern: /((?:^|[;{])[ \t]*)(?!\d)\w+(?:\.\w+)*(?=[ \t]*:)/m,
				lookbehind: true
			},
			{
				pattern: /((?:^|[;{])[ \t]*)property[ \t]+(?!\d)\w+(?:\.\w+)*[ \t]+(?!\d)\w+(?:\.\w+)*(?=[ \t]*:)/m,
				lookbehind: true,
				inside: {
					'keyword': /^property/,
					'property': /\w+(?:\.\w+)*/
				}
			}
		],
		'javascript-expression': {
			pattern: RegExp(/(:[ \t]*)(?![\s;}[])(?:(?!$|[;}])<js>)+/.source.replace(/<js>/g, function () { return jsExpr; }), 'm'),
			lookbehind: true,
			greedy: true,
			alias: 'language-javascript',
			inside: Prism.languages.javascript
		},
		'string': {
			pattern: /"(?:\\.|[^\\"\r\n])*"/,
			greedy: true
		},
		'keyword': /\b(?:as|import|on)\b/,
		'punctuation': /[{}[\]:;,]/
	};

}(Prism));

Prism.languages.qore = Prism.languages.extend('clike', {
	'comment': {
		pattern: /(^|[^\\])(?:\/\*[\s\S]*?\*\/|(?:\/\/|#).*)/,
		lookbehind: true
	},
	// Overridden to allow unescaped multi-line strings
	'string': {
		pattern: /("|')(?:\\[\s\S]|(?!\1)[^\\])*\1/,
		greedy: true
	},
	'keyword': /\b(?:abstract|any|assert|binary|bool|boolean|break|byte|case|catch|char|class|code|const|continue|data|default|do|double|else|enum|extends|final|finally|float|for|goto|hash|if|implements|import|inherits|instanceof|int|interface|long|my|native|new|nothing|null|object|our|own|private|reference|rethrow|return|short|soft(?:bool|date|float|int|list|number|string)|static|strictfp|string|sub|super|switch|synchronized|this|throw|throws|transient|try|void|volatile|while)\b/,
	'boolean': /\b(?:false|true)\b/i,
	'function': /\$?\b(?!\d)\w+(?=\()/,
	'number': /\b(?:0b[01]+|0x(?:[\da-f]*\.)?[\da-fp\-]+|(?:\d+(?:\.\d+)?|\.\d+)(?:e\d+)?[df]|(?:\d+(?:\.\d+)?|\.\d+))\b/i,
	'operator': {
		pattern: /(^|[^.])(?:\+[+=]?|-[-=]?|[!=](?:==?|~)?|>>?=?|<(?:=>?|<=?)?|&[&=]?|\|[|=]?|[*\/%^]=?|[~?])/,
		lookbehind: true
	},
	'variable': /\$(?!\d)\w+\b/
});

Prism.languages.r = {
	'comment': /#.*/,
	'string': {
		pattern: /(['"])(?:\\.|(?!\1)[^\\\r\n])*\1/,
		greedy: true
	},
	'percent-operator': {
		// Includes user-defined operators
		// and %%, %*%, %/%, %in%, %o%, %x%
		pattern: /%[^%\s]*%/,
		alias: 'operator'
	},
	'boolean': /\b(?:FALSE|TRUE)\b/,
	'ellipsis': /\.\.(?:\.|\d+)/,
	'number': [
		/\b(?:Inf|NaN)\b/,
		/(?:\b0x[\dA-Fa-f]+(?:\.\d*)?|\b\d+(?:\.\d*)?|\B\.\d+)(?:[EePp][+-]?\d+)?[iL]?/
	],
	'keyword': /\b(?:NA|NA_character_|NA_complex_|NA_integer_|NA_real_|NULL|break|else|for|function|if|in|next|repeat|while)\b/,
	'operator': /->?>?|<(?:=|<?-)?|[>=!]=?|::?|&&?|\|\|?|[+*\/^$@~]/,
	'punctuation': /[(){}\[\],;]/
};

(function (Prism) {

	var javascript = Prism.util.clone(Prism.languages.javascript);

	var space = /(?:\s|\/\/.*(?!.)|\/\*(?:[^*]|\*(?!\/))\*\/)/.source;
	var braces = /(?:\{(?:\{(?:\{[^{}]*\}|[^{}])*\}|[^{}])*\})/.source;
	var spread = /(?:\{<S>*\.{3}(?:[^{}]|<BRACES>)*\})/.source;

	/**
	 * @param {string} source
	 * @param {string} [flags]
	 */
	function re(source, flags) {
		source = source
			.replace(/<S>/g, function () { return space; })
			.replace(/<BRACES>/g, function () { return braces; })
			.replace(/<SPREAD>/g, function () { return spread; });
		return RegExp(source, flags);
	}

	spread = re(spread).source;


	Prism.languages.jsx = Prism.languages.extend('markup', javascript);
	Prism.languages.jsx.tag.pattern = re(
		/<\/?(?:[\w.:-]+(?:<S>+(?:[\w.:$-]+(?:=(?:"(?:\\[\s\S]|[^\\"])*"|'(?:\\[\s\S]|[^\\'])*'|[^\s{'"/>=]+|<BRACES>))?|<SPREAD>))*<S>*\/?)?>/.source
	);

	Prism.languages.jsx.tag.inside['tag'].pattern = /^<\/?[^\s>\/]*/;
	Prism.languages.jsx.tag.inside['attr-value'].pattern = /=(?!\{)(?:"(?:\\[\s\S]|[^\\"])*"|'(?:\\[\s\S]|[^\\'])*'|[^\s'">]+)/;
	Prism.languages.jsx.tag.inside['tag'].inside['class-name'] = /^[A-Z]\w*(?:\.[A-Z]\w*)*$/;
	Prism.languages.jsx.tag.inside['comment'] = javascript['comment'];

	Prism.languages.insertBefore('inside', 'attr-name', {
		'spread': {
			pattern: re(/<SPREAD>/.source),
			inside: Prism.languages.jsx
		}
	}, Prism.languages.jsx.tag);

	Prism.languages.insertBefore('inside', 'special-attr', {
		'script': {
			// Allow for two levels of nesting
			pattern: re(/=<BRACES>/.source),
			alias: 'language-javascript',
			inside: {
				'script-punctuation': {
					pattern: /^=(?=\{)/,
					alias: 'punctuation'
				},
				rest: Prism.languages.jsx
			},
		}
	}, Prism.languages.jsx.tag);

	// The following will handle plain text inside tags
	var stringifyToken = function (token) {
		if (!token) {
			return '';
		}
		if (typeof token === 'string') {
			return token;
		}
		if (typeof token.content === 'string') {
			return token.content;
		}
		return token.content.map(stringifyToken).join('');
	};

	var walkTokens = function (tokens) {
		var openedTags = [];
		for (var i = 0; i < tokens.length; i++) {
			var token = tokens[i];
			var notTagNorBrace = false;

			if (typeof token !== 'string') {
				if (token.type === 'tag' && token.content[0] && token.content[0].type === 'tag') {
					// We found a tag, now find its kind

					if (token.content[0].content[0].content === '</') {
						// Closing tag
						if (openedTags.length > 0 && openedTags[openedTags.length - 1].tagName === stringifyToken(token.content[0].content[1])) {
							// Pop matching opening tag
							openedTags.pop();
						}
					} else {
						if (token.content[token.content.length - 1].content === '/>') {
							// Autoclosed tag, ignore
						} else {
							// Opening tag
							openedTags.push({
								tagName: stringifyToken(token.content[0].content[1]),
								openedBraces: 0
							});
						}
					}
				} else if (openedTags.length > 0 && token.type === 'punctuation' && token.content === '{') {

					// Here we might have entered a JSX context inside a tag
					openedTags[openedTags.length - 1].openedBraces++;

				} else if (openedTags.length > 0 && openedTags[openedTags.length - 1].openedBraces > 0 && token.type === 'punctuation' && token.content === '}') {

					// Here we might have left a JSX context inside a tag
					openedTags[openedTags.length - 1].openedBraces--;

				} else {
					notTagNorBrace = true;
				}
			}
			if (notTagNorBrace || typeof token === 'string') {
				if (openedTags.length > 0 && openedTags[openedTags.length - 1].openedBraces === 0) {
					// Here we are inside a tag, and not inside a JSX context.
					// That's plain text: drop any tokens matched.
					var plainText = stringifyToken(token);

					// And merge text with adjacent text
					if (i < tokens.length - 1 && (typeof tokens[i + 1] === 'string' || tokens[i + 1].type === 'plain-text')) {
						plainText += stringifyToken(tokens[i + 1]);
						tokens.splice(i + 1, 1);
					}
					if (i > 0 && (typeof tokens[i - 1] === 'string' || tokens[i - 1].type === 'plain-text')) {
						plainText = stringifyToken(tokens[i - 1]) + plainText;
						tokens.splice(i - 1, 1);
						i--;
					}

					tokens[i] = new Prism.Token('plain-text', plainText, null, plainText);
				}
			}

			if (token.content && typeof token.content !== 'string') {
				walkTokens(token.content);
			}
		}
	};

	Prism.hooks.add('after-tokenize', function (env) {
		if (env.language !== 'jsx' && env.language !== 'tsx') {
			return;
		}
		walkTokens(env.tokens);
	});

}(Prism));

(function (Prism) {
	var typescript = Prism.util.clone(Prism.languages.typescript);
	Prism.languages.tsx = Prism.languages.extend('jsx', typescript);

	// doesn't work with TS because TS is too complex
	delete Prism.languages.tsx['parameter'];
	delete Prism.languages.tsx['literal-property'];

	// This will prevent collisions between TSX tags and TS generic types.
	// Idea by https://github.com/karlhorky
	// Discussion: https://github.com/PrismJS/prism/issues/2594#issuecomment-710666928
	var tag = Prism.languages.tsx.tag;
	tag.pattern = RegExp(/(^|[^\w$]|(?=<\/))/.source + '(?:' + tag.pattern.source + ')', tag.pattern.flags);
	tag.lookbehind = true;
}(Prism));

(function (Prism) {

	var specialEscape = {
		pattern: /\\[\\(){}[\]^$+*?|.]/,
		alias: 'escape'
	};
	var escape = /\\(?:x[\da-fA-F]{2}|u[\da-fA-F]{4}|u\{[\da-fA-F]+\}|0[0-7]{0,2}|[123][0-7]{2}|c[a-zA-Z]|.)/;
	var charSet = {
		pattern: /\.|\\[wsd]|\\p\{[^{}]+\}/i,
		alias: 'class-name'
	};
	var charSetWithoutDot = {
		pattern: /\\[wsd]|\\p\{[^{}]+\}/i,
		alias: 'class-name'
	};

	var rangeChar = '(?:[^\\\\-]|' + escape.source + ')';
	var range = RegExp(rangeChar + '-' + rangeChar);

	// the name of a capturing group
	var groupName = {
		pattern: /(<|')[^<>']+(?=[>']$)/,
		lookbehind: true,
		alias: 'variable'
	};

	Prism.languages.regex = {
		'char-class': {
			pattern: /((?:^|[^\\])(?:\\\\)*)\[(?:[^\\\]]|\\[\s\S])*\]/,
			lookbehind: true,
			inside: {
				'char-class-negation': {
					pattern: /(^\[)\^/,
					lookbehind: true,
					alias: 'operator'
				},
				'char-class-punctuation': {
					pattern: /^\[|\]$/,
					alias: 'punctuation'
				},
				'range': {
					pattern: range,
					inside: {
						'escape': escape,
						'range-punctuation': {
							pattern: /-/,
							alias: 'operator'
						}
					}
				},
				'special-escape': specialEscape,
				'char-set': charSetWithoutDot,
				'escape': escape
			}
		},
		'special-escape': specialEscape,
		'char-set': charSet,
		'backreference': [
			{
				// a backreference which is not an octal escape
				pattern: /\\(?![123][0-7]{2})[1-9]/,
				alias: 'keyword'
			},
			{
				pattern: /\\k<[^<>']+>/,
				alias: 'keyword',
				inside: {
					'group-name': groupName
				}
			}
		],
		'anchor': {
			pattern: /[$^]|\\[ABbGZz]/,
			alias: 'function'
		},
		'escape': escape,
		'group': [
			{
				// https://docs.oracle.com/javase/10/docs/api/java/util/regex/Pattern.html
				// https://docs.microsoft.com/en-us/dotnet/standard/base-types/regular-expression-language-quick-reference?view=netframework-4.7.2#grouping-constructs

				// (), (?<name>), (?'name'), (?>), (?:), (?=), (?!), (?<=), (?<!), (?is-m), (?i-m:)
				pattern: /\((?:\?(?:<[^<>']+>|'[^<>']+'|[>:]|<?[=!]|[idmnsuxU]+(?:-[idmnsuxU]+)?:?))?/,
				alias: 'punctuation',
				inside: {
					'group-name': groupName
				}
			},
			{
				pattern: /\)/,
				alias: 'punctuation'
			}
		],
		'quantifier': {
			pattern: /(?:[+*?]|\{\d+(?:,\d*)?\})[?+]?/,
			alias: 'number'
		},
		'alternation': {
			pattern: /\|/,
			alias: 'keyword'
		}
	};

}(Prism));

(function (Prism) {

	var multilineComment = /\/\*(?:[^*/]|\*(?!\/)|\/(?!\*)|<self>)*\*\//.source;
	for (var i = 0; i < 2; i++) {
		// support 4 levels of nested comments
		multilineComment = multilineComment.replace(/<self>/g, function () { return multilineComment; });
	}
	multilineComment = multilineComment.replace(/<self>/g, function () { return /[^\s\S]/.source; });


	Prism.languages.rust = {
		'comment': [
			{
				pattern: RegExp(/(^|[^\\])/.source + multilineComment),
				lookbehind: true,
				greedy: true
			},
			{
				pattern: /(^|[^\\:])\/\/.*/,
				lookbehind: true,
				greedy: true
			}
		],
		'string': {
			pattern: /b?"(?:\\[\s\S]|[^\\"])*"|b?r(#*)"(?:[^"]|"(?!\1))*"\1/,
			greedy: true
		},
		'char': {
			pattern: /b?'(?:\\(?:x[0-7][\da-fA-F]|u\{(?:[\da-fA-F]_*){1,6}\}|.)|[^\\\r\n\t'])'/,
			greedy: true
		},
		'attribute': {
			pattern: /#!?\[(?:[^\[\]"]|"(?:\\[\s\S]|[^\\"])*")*\]/,
			greedy: true,
			alias: 'attr-name',
			inside: {
				'string': null // see below
			}
		},

		// Closure params should not be confused with bitwise OR |
		'closure-params': {
			pattern: /([=(,:]\s*|\bmove\s*)\|[^|]*\||\|[^|]*\|(?=\s*(?:\{|->))/,
			lookbehind: true,
			greedy: true,
			inside: {
				'closure-punctuation': {
					pattern: /^\||\|$/,
					alias: 'punctuation'
				},
				rest: null // see below
			}
		},

		'lifetime-annotation': {
			pattern: /'\w+/,
			alias: 'symbol'
		},

		'fragment-specifier': {
			pattern: /(\$\w+:)[a-z]+/,
			lookbehind: true,
			alias: 'punctuation'
		},
		'variable': /\$\w+/,

		'function-definition': {
			pattern: /(\bfn\s+)\w+/,
			lookbehind: true,
			alias: 'function'
		},
		'type-definition': {
			pattern: /(\b(?:enum|struct|trait|type|union)\s+)\w+/,
			lookbehind: true,
			alias: 'class-name'
		},
		'module-declaration': [
			{
				pattern: /(\b(?:crate|mod)\s+)[a-z][a-z_\d]*/,
				lookbehind: true,
				alias: 'namespace'
			},
			{
				pattern: /(\b(?:crate|self|super)\s*)::\s*[a-z][a-z_\d]*\b(?:\s*::(?:\s*[a-z][a-z_\d]*\s*::)*)?/,
				lookbehind: true,
				alias: 'namespace',
				inside: {
					'punctuation': /::/
				}
			}
		],
		'keyword': [
			// https://github.com/rust-lang/reference/blob/master/src/keywords.md
			/\b(?:Self|abstract|as|async|await|become|box|break|const|continue|crate|do|dyn|else|enum|extern|final|fn|for|if|impl|in|let|loop|macro|match|mod|move|mut|override|priv|pub|ref|return|self|static|struct|super|trait|try|type|typeof|union|unsafe|unsized|use|virtual|where|while|yield)\b/,
			// primitives and str
			// https://doc.rust-lang.org/stable/rust-by-example/primitives.html
			/\b(?:bool|char|f(?:32|64)|[ui](?:8|16|32|64|128|size)|str)\b/
		],

		// functions can technically start with an upper-case letter, but this will introduce a lot of false positives
		// and Rust's naming conventions recommend snake_case anyway.
		// https://doc.rust-lang.org/1.0.0/style/style/naming/README.html
		'function': /\b[a-z_]\w*(?=\s*(?:::\s*<|\())/,
		'macro': {
			pattern: /\b\w+!/,
			alias: 'property'
		},
		'constant': /\b[A-Z_][A-Z_\d]+\b/,
		'class-name': /\b[A-Z]\w*\b/,

		'namespace': {
			pattern: /(?:\b[a-z][a-z_\d]*\s*::\s*)*\b[a-z][a-z_\d]*\s*::(?!\s*<)/,
			inside: {
				'punctuation': /::/
			}
		},

		// Hex, oct, bin, dec numbers with visual separators and type suffix
		'number': /\b(?:0x[\dA-Fa-f](?:_?[\dA-Fa-f])*|0o[0-7](?:_?[0-7])*|0b[01](?:_?[01])*|(?:(?:\d(?:_?\d)*)?\.)?\d(?:_?\d)*(?:[Ee][+-]?\d+)?)(?:_?(?:f32|f64|[iu](?:8|16|32|64|size)?))?\b/,
		'boolean': /\b(?:false|true)\b/,
		'punctuation': /->|\.\.=|\.{1,3}|::|[{}[\];(),:]/,
		'operator': /[-+*\/%!^]=?|=[=>]?|&[&=]?|\|[|=]?|<<?=?|>>?=?|[@?]/
	};

	Prism.languages.rust['closure-params'].inside.rest = Prism.languages.rust;
	Prism.languages.rust['attribute'].inside['string'] = Prism.languages.rust['string'];

}(Prism));

(function (Prism) {

	var stringPattern = /(?:"(?:""|[^"])*"(?!")|'(?:''|[^'])*'(?!'))/.source;

	var number = /\b(?:\d[\da-f]*x|\d+(?:\.\d+)?(?:e[+-]?\d+)?)\b/i;
	var numericConstant = {
		pattern: RegExp(stringPattern + '[bx]'),
		alias: 'number'
	};

	var macroVariable = {
		pattern: /&[a-z_]\w*/i
	};

	var macroKeyword = {
		pattern: /((?:^|\s|=|\())%(?:ABORT|BY|CMS|COPY|DISPLAY|DO|ELSE|END|EVAL|GLOBAL|GO|GOTO|IF|INC|INCLUDE|INDEX|INPUT|KTRIM|LENGTH|LET|LIST|LOCAL|PUT|QKTRIM|QSCAN|QSUBSTR|QSYSFUNC|QUPCASE|RETURN|RUN|SCAN|SUBSTR|SUPERQ|SYMDEL|SYMEXIST|SYMGLOBL|SYMLOCAL|SYSCALL|SYSEVALF|SYSEXEC|SYSFUNC|SYSGET|SYSRPUT|THEN|TO|TSO|UNQUOTE|UNTIL|UPCASE|WHILE|WINDOW)\b/i,
		lookbehind: true,
		alias: 'keyword'
	};

	var step = {
		pattern: /(^|\s)(?:proc\s+\w+|data(?!=)|quit|run)\b/i,
		alias: 'keyword',
		lookbehind: true
	};

	var comment = [
		/\/\*[\s\S]*?\*\//,
		{
			pattern: /(^[ \t]*|;\s*)\*[^;]*;/m,
			lookbehind: true
		}
	];

	var string = {
		pattern: RegExp(stringPattern),
		greedy: true
	};

	var punctuation = /[$%@.(){}\[\];,\\]/;

	var func = {
		pattern: /%?\b\w+(?=\()/,
		alias: 'keyword'
	};

	var args = {
		'function': func,
		'arg-value': {
			pattern: /(=\s*)[A-Z\.]+/i,
			lookbehind: true
		},
		'operator': /=/,
		'macro-variable': macroVariable,
		'arg': {
			pattern: /[A-Z]+/i,
			alias: 'keyword'
		},
		'number': number,
		'numeric-constant': numericConstant,
		'punctuation': punctuation,
		'string': string
	};

	var format = {
		pattern: /\b(?:format|put)\b=?[\w'$.]+/i,
		inside: {
			'keyword': /^(?:format|put)(?==)/i,
			'equals': /=/,
			'format': {
				pattern: /(?:\w|\$\d)+\.\d?/,
				alias: 'number'
			}
		}
	};

	var altformat = {
		pattern: /\b(?:format|put)\s+[\w']+(?:\s+[$.\w]+)+(?=;)/i,
		inside: {
			'keyword': /^(?:format|put)/i,
			'format': {
				pattern: /[\w$]+\.\d?/,
				alias: 'number'
			}
		}
	};

	var globalStatements = {
		pattern: /((?:^|\s)=?)(?:catname|checkpoint execute_always|dm|endsas|filename|footnote|%include|libname|%list|lock|missing|options|page|resetline|%run|sasfile|skip|sysecho|title\d?)\b/i,
		lookbehind: true,
		alias: 'keyword'
	};

	var submitStatement = {
		pattern: /(^|\s)(?:submit(?:\s+(?:load|norun|parseonly))?|endsubmit)\b/i,
		lookbehind: true,
		alias: 'keyword'
	};

	var actionSets = /aStore|accessControl|aggregation|audio|autotune|bayesianNetClassifier|bioMedImage|boolRule|builtins|cardinality|cdm|clustering|conditionalRandomFields|configuration|copula|countreg|dataDiscovery|dataPreprocess|dataSciencePilot|dataStep|decisionTree|deduplication|deepLearn|deepNeural|deepRnn|ds2|ecm|entityRes|espCluster|explainModel|factmac|fastKnn|fcmpact|fedSql|freqTab|gVarCluster|gam|gleam|graphSemiSupLearn|hiddenMarkovModel|hyperGroup|ica|image|iml|kernalPca|langModel|ldaTopic|loadStreams|mbc|mixed|mlTools|modelPublishing|network|neuralNet|nmf|nonParametricBayes|nonlinear|optNetwork|optimization|panel|pca|percentile|phreg|pls|qkb|qlim|quantreg|recommend|regression|reinforcementLearn|robustPca|ruleMining|sampling|sandwich|sccasl|search(?:Analytics)?|sentimentAnalysis|sequence|session(?:Prop)?|severity|simSystem|simple|smartData|sparkEmbeddedProcess|sparseML|spatialreg|spc|stabilityMonitoring|svDataDescription|svm|table|text(?:Filters|Frequency|Mining|Parse|Rule(?:Develop|Score)|Topic|Util)|timeData|transpose|tsInfo|tsReconcile|uniTimeSeries|varReduce/.source;

	var casActions = {
		pattern: RegExp(/(^|\s)(?:action\s+)?(?:<act>)\.[a-z]+\b[^;]+/.source.replace(/<act>/g, function () { return actionSets; }), 'i'),
		lookbehind: true,
		inside: {
			'keyword': RegExp(/(?:<act>)\.[a-z]+\b/.source.replace(/<act>/g, function () { return actionSets; }), 'i'),
			'action': {
				pattern: /(?:action)/i,
				alias: 'keyword'
			},
			'comment': comment,
			'function': func,
			'arg-value': args['arg-value'],
			'operator': args.operator,
			'argument': args.arg,
			'number': number,
			'numeric-constant': numericConstant,
			'punctuation': punctuation,
			'string': string
		}
	};

	var keywords = {
		pattern: /((?:^|\s)=?)(?:after|analysis|and|array|barchart|barwidth|begingraph|by|call|cas|cbarline|cfill|class(?:lev)?|close|column|computed?|contains|continue|data(?==)|define|delete|describe|document|do\s+over|do|dol|drop|dul|else|end(?:comp|source)?|entryTitle|eval(?:uate)?|exec(?:ute)?|exit|file(?:name)?|fill(?:attrs)?|flist|fnc|function(?:list)?|global|goto|group(?:by)?|headline|headskip|histogram|if|infile|keep|keylabel|keyword|label|layout|leave|legendlabel|length|libname|loadactionset|merge|midpoints|_?null_|name|noobs|nowd|ods|options|or|otherwise|out(?:put)?|over(?:lay)?|plot|print|put|raise|ranexp|rannor|rbreak|retain|return|select|session|sessref|set|source|statgraph|sum|summarize|table|temp|terminate|then\s+do|then|title\d?|to|var|when|where|xaxisopts|y2axisopts|yaxisopts)\b/i,
		lookbehind: true,
	};

	Prism.languages.sas = {
		'datalines': {
			pattern: /^([ \t]*)(?:cards|(?:data)?lines);[\s\S]+?^[ \t]*;/im,
			lookbehind: true,
			alias: 'string',
			inside: {
				'keyword': {
					pattern: /^(?:cards|(?:data)?lines)/i
				},
				'punctuation': /;/
			}
		},

		'proc-sql': {
			pattern: /(^proc\s+(?:fed)?sql(?:\s+[\w|=]+)?;)[\s\S]+?(?=^(?:proc\s+\w+|data|quit|run);|(?![\s\S]))/im,
			lookbehind: true,
			inside: {
				'sql': {
					pattern: RegExp(/^[ \t]*(?:select|alter\s+table|(?:create|describe|drop)\s+(?:index|table(?:\s+constraints)?|view)|create\s+unique\s+index|insert\s+into|update)(?:<str>|[^;"'])+;/.source.replace(/<str>/g, function () { return stringPattern; }), 'im'),
					alias: 'language-sql',
					inside: Prism.languages.sql
				},
				'global-statements': globalStatements,
				'sql-statements': {
					pattern: /(^|\s)(?:disconnect\s+from|begin|commit|exec(?:ute)?|reset|rollback|validate)\b/i,
					lookbehind: true,
					alias: 'keyword'
				},
				'number': number,
				'numeric-constant': numericConstant,
				'punctuation': punctuation,
				'string': string
			}
		},

		'proc-groovy': {
			pattern: /(^proc\s+groovy(?:\s+[\w|=]+)?;)[\s\S]+?(?=^(?:proc\s+\w+|data|quit|run);|(?![\s\S]))/im,
			lookbehind: true,
			inside: {
				'comment': comment,
				'groovy': {
					pattern: RegExp(/(^[ \t]*submit(?:\s+(?:load|norun|parseonly))?)(?:<str>|[^"'])+?(?=endsubmit;)/.source.replace(/<str>/g, function () { return stringPattern; }), 'im'),
					lookbehind: true,
					alias: 'language-groovy',
					inside: Prism.languages.groovy
				},
				'keyword': keywords,
				'submit-statement': submitStatement,
				'global-statements': globalStatements,
				'number': number,
				'numeric-constant': numericConstant,
				'punctuation': punctuation,
				'string': string
			}
		},

		'proc-lua': {
			pattern: /(^proc\s+lua(?:\s+[\w|=]+)?;)[\s\S]+?(?=^(?:proc\s+\w+|data|quit|run);|(?![\s\S]))/im,
			lookbehind: true,
			inside: {
				'comment': comment,
				'lua': {
					pattern: RegExp(/(^[ \t]*submit(?:\s+(?:load|norun|parseonly))?)(?:<str>|[^"'])+?(?=endsubmit;)/.source.replace(/<str>/g, function () { return stringPattern; }), 'im'),
					lookbehind: true,
					alias: 'language-lua',
					inside: Prism.languages.lua
				},
				'keyword': keywords,
				'submit-statement': submitStatement,
				'global-statements': globalStatements,
				'number': number,
				'numeric-constant': numericConstant,
				'punctuation': punctuation,
				'string': string
			}
		},

		'proc-cas': {
			pattern: /(^proc\s+cas(?:\s+[\w|=]+)?;)[\s\S]+?(?=^(?:proc\s+\w+|quit|data);|(?![\s\S]))/im,
			lookbehind: true,
			inside: {
				'comment': comment,
				'statement-var': {
					pattern: /((?:^|\s)=?)saveresult\s[^;]+/im,
					lookbehind: true,
					inside: {

						'statement': {
							pattern: /^saveresult\s+\S+/i,
							inside: {
								keyword: /^(?:saveresult)/i
							}
						},
						rest: args
					}
				},
				'cas-actions': casActions,
				'statement': {
					pattern: /((?:^|\s)=?)(?:default|(?:un)?set|on|output|upload)[^;]+/im,
					lookbehind: true,
					inside: args
				},
				'step': step,
				'keyword': keywords,
				'function': func,
				'format': format,
				'altformat': altformat,
				'global-statements': globalStatements,
				'number': number,
				'numeric-constant': numericConstant,
				'punctuation': punctuation,
				'string': string
			}
		},

		'proc-args': {
			pattern: RegExp(/(^proc\s+\w+\s+)(?!\s)(?:[^;"']|<str>)+;/.source.replace(/<str>/g, function () { return stringPattern; }), 'im'),
			lookbehind: true,
			inside: args
		},
		/*Special keywords within macros*/
		'macro-keyword': macroKeyword,
		'macro-variable': macroVariable,
		'macro-string-functions': {
			pattern: /((?:^|\s|=))%(?:BQUOTE|NRBQUOTE|NRQUOTE|NRSTR|QUOTE|STR)\(.*?(?:[^%]\))/i,
			lookbehind: true,
			inside: {
				'function': {
					pattern: /%(?:BQUOTE|NRBQUOTE|NRQUOTE|NRSTR|QUOTE|STR)/i,
					alias: 'keyword'
				},
				'macro-keyword': macroKeyword,
				'macro-variable': macroVariable,
				'escaped-char': {
					pattern: /%['"()<>=¬^~;,#]/,
				},
				'punctuation': punctuation
			}
		},
		'macro-declaration': {
			pattern: /^%macro[^;]+(?=;)/im,
			inside: {
				'keyword': /%macro/i,
			}
		},
		'macro-end': {
			pattern: /^%mend[^;]+(?=;)/im,
			inside: {
				'keyword': /%mend/i,
			}
		},
		/*%_zscore(headcir, _lhc, _mhc, _shc, headcz, headcpct, _Fheadcz); */
		'macro': {
			pattern: /%_\w+(?=\()/,
			alias: 'keyword'
		},
		'input': {
			pattern: /\binput\s[-\w\s/*.$&]+;/i,
			inside: {
				'input': {
					alias: 'keyword',
					pattern: /^input/i,
				},
				'comment': comment,
				'number': number,
				'numeric-constant': numericConstant
			}
		},
		'options-args': {
			pattern: /(^options)[-'"|/\\<>*+=:()\w\s]*(?=;)/im,
			lookbehind: true,
			inside: args
		},
		'cas-actions': casActions,
		'comment': comment,
		'function': func,
		'format': format,
		'altformat': altformat,
		'numeric-constant': numericConstant,
		'datetime': {
			// '1jan2013'd, '9:25:19pm't, '18jan2003:9:27:05am'dt
			pattern: RegExp(stringPattern + '(?:dt?|t)'),
			alias: 'number'
		},
		'string': string,
		'step': step,
		'keyword': keywords,
		// In SAS Studio syntax highlighting, these operators are styled like keywords
		'operator-keyword': {
			pattern: /\b(?:eq|ge|gt|in|le|lt|ne|not)\b/i,
			alias: 'operator'
		},
		// Decimal (1.2e23), hexadecimal (0c1x)
		'number': number,
		'operator': /\*\*?|\|\|?|!!?|¦¦?|<[>=]?|>[<=]?|[-+\/=&]|[~¬^]=?/,
		'punctuation': punctuation
	};

}(Prism));

(function (Prism) {
	Prism.languages.sass = Prism.languages.extend('css', {
		// Sass comments don't need to be closed, only indented
		'comment': {
			pattern: /^([ \t]*)\/[\/*].*(?:(?:\r?\n|\r)\1[ \t].+)*/m,
			lookbehind: true,
			greedy: true
		}
	});

	Prism.languages.insertBefore('sass', 'atrule', {
		// We want to consume the whole line
		'atrule-line': {
			// Includes support for = and + shortcuts
			pattern: /^(?:[ \t]*)[@+=].+/m,
			greedy: true,
			inside: {
				'atrule': /(?:@[\w-]+|[+=])/
			}
		}
	});
	delete Prism.languages.sass.atrule;


	var variable = /\$[-\w]+|#\{\$[-\w]+\}/;
	var operator = [
		/[+*\/%]|[=!]=|<=?|>=?|\b(?:and|not|or)\b/,
		{
			pattern: /(\s)-(?=\s)/,
			lookbehind: true
		}
	];

	Prism.languages.insertBefore('sass', 'property', {
		// We want to consume the whole line
		'variable-line': {
			pattern: /^[ \t]*\$.+/m,
			greedy: true,
			inside: {
				'punctuation': /:/,
				'variable': variable,
				'operator': operator
			}
		},
		// We want to consume the whole line
		'property-line': {
			pattern: /^[ \t]*(?:[^:\s]+ *:.*|:[^:\s].*)/m,
			greedy: true,
			inside: {
				'property': [
					/[^:\s]+(?=\s*:)/,
					{
						pattern: /(:)[^:\s]+/,
						lookbehind: true
					}
				],
				'punctuation': /:/,
				'variable': variable,
				'operator': operator,
				'important': Prism.languages.sass.important
			}
		}
	});
	delete Prism.languages.sass.property;
	delete Prism.languages.sass.important;

	// Now that whole lines for other patterns are consumed,
	// what's left should be selectors
	Prism.languages.insertBefore('sass', 'punctuation', {
		'selector': {
			pattern: /^([ \t]*)\S(?:,[^,\r\n]+|[^,\r\n]*)(?:,[^,\r\n]+)*(?:,(?:\r?\n|\r)\1[ \t]+\S(?:,[^,\r\n]+|[^,\r\n]*)(?:,[^,\r\n]+)*)*/m,
			lookbehind: true,
			greedy: true
		}
	});

}(Prism));

Prism.languages.scss = Prism.languages.extend('css', {
	'comment': {
		pattern: /(^|[^\\])(?:\/\*[\s\S]*?\*\/|\/\/.*)/,
		lookbehind: true
	},
	'atrule': {
		pattern: /@[\w-](?:\([^()]+\)|[^()\s]|\s+(?!\s))*?(?=\s+[{;])/,
		inside: {
			'rule': /@[\w-]+/
			// See rest below
		}
	},
	// url, compassified
	'url': /(?:[-a-z]+-)?url(?=\()/i,
	// CSS selector regex is not appropriate for Sass
	// since there can be lot more things (var, @ directive, nesting..)
	// a selector must start at the end of a property or after a brace (end of other rules or nesting)
	// it can contain some characters that aren't used for defining rules or end of selector, & (parent selector), or interpolated variable
	// the end of a selector is found when there is no rules in it ( {} or {\s}) or if there is a property (because an interpolated var
	// can "pass" as a selector- e.g: proper#{$erty})
	// this one was hard to do, so please be careful if you edit this one :)
	'selector': {
		// Initial look-ahead is used to prevent matching of blank selectors
		pattern: /(?=\S)[^@;{}()]?(?:[^@;{}()\s]|\s+(?!\s)|#\{\$[-\w]+\})+(?=\s*\{(?:\}|\s|[^}][^:{}]*[:{][^}]))/,
		inside: {
			'parent': {
				pattern: /&/,
				alias: 'important'
			},
			'placeholder': /%[-\w]+/,
			'variable': /\$[-\w]+|#\{\$[-\w]+\}/
		}
	},
	'property': {
		pattern: /(?:[-\w]|\$[-\w]|#\{\$[-\w]+\})+(?=\s*:)/,
		inside: {
			'variable': /\$[-\w]+|#\{\$[-\w]+\}/
		}
	}
});

Prism.languages.insertBefore('scss', 'atrule', {
	'keyword': [
		/@(?:content|debug|each|else(?: if)?|extend|for|forward|function|if|import|include|mixin|return|use|warn|while)\b/i,
		{
			pattern: /( )(?:from|through)(?= )/,
			lookbehind: true
		}
	]
});

Prism.languages.insertBefore('scss', 'important', {
	// var and interpolated vars
	'variable': /\$[-\w]+|#\{\$[-\w]+\}/
});

Prism.languages.insertBefore('scss', 'function', {
	'module-modifier': {
		pattern: /\b(?:as|hide|show|with)\b/i,
		alias: 'keyword'
	},
	'placeholder': {
		pattern: /%[-\w]+/,
		alias: 'selector'
	},
	'statement': {
		pattern: /\B!(?:default|optional)\b/i,
		alias: 'keyword'
	},
	'boolean': /\b(?:false|true)\b/,
	'null': {
		pattern: /\bnull\b/,
		alias: 'keyword'
	},
	'operator': {
		pattern: /(\s)(?:[-+*\/%]|[=!]=|<=?|>=?|and|not|or)(?=\s)/,
		lookbehind: true
	}
});

Prism.languages.scss['atrule'].inside.rest = Prism.languages.scss;

Prism.languages.scala = Prism.languages.extend('java', {
	'triple-quoted-string': {
		pattern: /"""[\s\S]*?"""/,
		greedy: true,
		alias: 'string'
	},
	'string': {
		pattern: /("|')(?:\\.|(?!\1)[^\\\r\n])*\1/,
		greedy: true
	},
	'keyword': /<-|=>|\b(?:abstract|case|catch|class|def|derives|do|else|enum|extends|extension|final|finally|for|forSome|given|if|implicit|import|infix|inline|lazy|match|new|null|object|opaque|open|override|package|private|protected|return|sealed|self|super|this|throw|trait|transparent|try|type|using|val|var|while|with|yield)\b/,
	'number': /\b0x(?:[\da-f]*\.)?[\da-f]+|(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:e\d+)?[dfl]?/i,
	'builtin': /\b(?:Any|AnyRef|AnyVal|Boolean|Byte|Char|Double|Float|Int|Long|Nothing|Short|String|Unit)\b/,
	'symbol': /'[^\d\s\\]\w*/
});

Prism.languages.insertBefore('scala', 'triple-quoted-string', {
	'string-interpolation': {
		pattern: /\b[a-z]\w*(?:"""(?:[^$]|\$(?:[^{]|\{(?:[^{}]|\{[^{}]*\})*\}))*?"""|"(?:[^$"\r\n]|\$(?:[^{]|\{(?:[^{}]|\{[^{}]*\})*\}))*")/i,
		greedy: true,
		inside: {
			'id': {
				pattern: /^\w+/,
				greedy: true,
				alias: 'function'
			},
			'escape': {
				pattern: /\\\$"|\$[$"]/,
				greedy: true,
				alias: 'symbol'
			},
			'interpolation': {
				pattern: /\$(?:\w+|\{(?:[^{}]|\{[^{}]*\})*\})/,
				greedy: true,
				inside: {
					'punctuation': /^\$\{?|\}$/,
					'expression': {
						pattern: /[\s\S]+/,
						inside: Prism.languages.scala
					}
				}
			},
			'string': /[\s\S]+/
		}
	}
});

delete Prism.languages.scala['class-name'];
delete Prism.languages.scala['function'];
delete Prism.languages.scala['constant'];

(function (Prism) {
	Prism.languages.scheme = {
		// this supports "normal" single-line comments:
		//   ; comment
		// and (potentially nested) multiline comments:
		//   #| comment #| nested |# still comment |#
		// (only 1 level of nesting is supported)
		'comment': /;.*|#;\s*(?:\((?:[^()]|\([^()]*\))*\)|\[(?:[^\[\]]|\[[^\[\]]*\])*\])|#\|(?:[^#|]|#(?!\|)|\|(?!#)|#\|(?:[^#|]|#(?!\|)|\|(?!#))*\|#)*\|#/,
		'string': {
			pattern: /"(?:[^"\\]|\\.)*"/,
			greedy: true
		},
		'symbol': {
			pattern: /'[^()\[\]#'\s]+/,
			greedy: true
		},
		'char': {
			pattern: /#\\(?:[ux][a-fA-F\d]+\b|[-a-zA-Z]+\b|[\uD800-\uDBFF][\uDC00-\uDFFF]|\S)/,
			greedy: true
		},
		'lambda-parameter': [
			// https://www.cs.cmu.edu/Groups/AI/html/r4rs/r4rs_6.html#SEC30
			{
				pattern: /((?:^|[^'`#])[(\[]lambda\s+)(?:[^|()\[\]'\s]+|\|(?:[^\\|]|\\.)*\|)/,
				lookbehind: true
			},
			{
				pattern: /((?:^|[^'`#])[(\[]lambda\s+[(\[])[^()\[\]']+/,
				lookbehind: true
			}
		],
		'keyword': {
			pattern: /((?:^|[^'`#])[(\[])(?:begin|case(?:-lambda)?|cond(?:-expand)?|define(?:-library|-macro|-record-type|-syntax|-values)?|defmacro|delay(?:-force)?|do|else|except|export|guard|if|import|include(?:-ci|-library-declarations)?|lambda|let(?:rec)?(?:-syntax|-values|\*)?|let\*-values|only|parameterize|prefix|(?:quasi-?)?quote|rename|set!|syntax-(?:case|rules)|unless|unquote(?:-splicing)?|when)(?=[()\[\]\s]|$)/,
			lookbehind: true
		},
		'builtin': {
			// all functions of the base library of R7RS plus some of built-ins of R5Rs
			pattern: /((?:^|[^'`#])[(\[])(?:abs|and|append|apply|assoc|ass[qv]|binary-port\?|boolean=?\?|bytevector(?:-append|-copy|-copy!|-length|-u8-ref|-u8-set!|\?)?|caar|cadr|call-with-(?:current-continuation|port|values)|call\/cc|car|cdar|cddr|cdr|ceiling|char(?:->integer|-ready\?|\?|<\?|<=\?|=\?|>\?|>=\?)|close-(?:input-port|output-port|port)|complex\?|cons|current-(?:error|input|output)-port|denominator|dynamic-wind|eof-object\??|eq\?|equal\?|eqv\?|error|error-object(?:-irritants|-message|\?)|eval|even\?|exact(?:-integer-sqrt|-integer\?|\?)?|expt|features|file-error\?|floor(?:-quotient|-remainder|\/)?|flush-output-port|for-each|gcd|get-output-(?:bytevector|string)|inexact\??|input-port(?:-open\?|\?)|integer(?:->char|\?)|lcm|length|list(?:->string|->vector|-copy|-ref|-set!|-tail|\?)?|make-(?:bytevector|list|parameter|string|vector)|map|max|member|memq|memv|min|modulo|negative\?|newline|not|null\?|number(?:->string|\?)|numerator|odd\?|open-(?:input|output)-(?:bytevector|string)|or|output-port(?:-open\?|\?)|pair\?|peek-char|peek-u8|port\?|positive\?|procedure\?|quotient|raise|raise-continuable|rational\?|rationalize|read-(?:bytevector|bytevector!|char|error\?|line|string|u8)|real\?|remainder|reverse|round|set-c[ad]r!|square|string(?:->list|->number|->symbol|->utf8|->vector|-append|-copy|-copy!|-fill!|-for-each|-length|-map|-ref|-set!|\?|<\?|<=\?|=\?|>\?|>=\?)?|substring|symbol(?:->string|\?|=\?)|syntax-error|textual-port\?|truncate(?:-quotient|-remainder|\/)?|u8-ready\?|utf8->string|values|vector(?:->list|->string|-append|-copy|-copy!|-fill!|-for-each|-length|-map|-ref|-set!|\?)?|with-exception-handler|write-(?:bytevector|char|string|u8)|zero\?)(?=[()\[\]\s]|$)/,
			lookbehind: true
		},
		'operator': {
			pattern: /((?:^|[^'`#])[(\[])(?:[-+*%/]|[<>]=?|=>?)(?=[()\[\]\s]|$)/,
			lookbehind: true
		},
		'number': {
			// The number pattern from [the R7RS spec](https://small.r7rs.org/attachment/r7rs.pdf).
			//
			// <number>      := <num 2>|<num 8>|<num 10>|<num 16>
			// <num R>       := <prefix R><complex R>
			// <complex R>   := <real R>(?:@<real R>|<imaginary R>)?|<imaginary R>
			// <imaginary R> := [+-](?:<ureal R>|(?:inf|nan)\.0)?i
			// <real R>      := [+-]?<ureal R>|[+-](?:inf|nan)\.0
			// <ureal R>     := <uint R>(?:\/<uint R>)?
			//                | <decimal R>
			//
			// <decimal 10>  := (?:\d+(?:\.\d*)?|\.\d+)(?:e[+-]?\d+)?
			// <uint R>      := <digit R>+
			// <prefix R>    := <radix R>(?:#[ei])?|(?:#[ei])?<radix R>
			// <radix 2>     := #b
			// <radix 8>     := #o
			// <radix 10>    := (?:#d)?
			// <radix 16>    := #x
			// <digit 2>     := [01]
			// <digit 8>     := [0-7]
			// <digit 10>    := \d
			// <digit 16>    := [0-9a-f]
			//
			// The problem with this grammar is that the resulting regex is way to complex, so we simplify by grouping all
			// non-decimal bases together. This results in a decimal (dec) and combined binary, octal, and hexadecimal (box)
			// pattern:
			pattern: RegExp(SortedBNF({
				'<ureal dec>': /\d+(?:\/\d+)|(?:\d+(?:\.\d*)?|\.\d+)(?:[esfdl][+-]?\d+)?/.source,
				'<real dec>': /[+-]?<ureal dec>|[+-](?:inf|nan)\.0/.source,
				'<imaginary dec>': /[+-](?:<ureal dec>|(?:inf|nan)\.0)?i/.source,
				'<complex dec>': /<real dec>(?:@<real dec>|<imaginary dec>)?|<imaginary dec>/.source,
				'<num dec>': /(?:#d(?:#[ei])?|#[ei](?:#d)?)?<complex dec>/.source,

				'<ureal box>': /[0-9a-f]+(?:\/[0-9a-f]+)?/.source,
				'<real box>': /[+-]?<ureal box>|[+-](?:inf|nan)\.0/.source,
				'<imaginary box>': /[+-](?:<ureal box>|(?:inf|nan)\.0)?i/.source,
				'<complex box>': /<real box>(?:@<real box>|<imaginary box>)?|<imaginary box>/.source,
				'<num box>': /#[box](?:#[ei])?|(?:#[ei])?#[box]<complex box>/.source,

				'<number>': /(^|[()\[\]\s])(?:<num dec>|<num box>)(?=[()\[\]\s]|$)/.source,
			}), 'i'),
			lookbehind: true
		},
		'boolean': {
			pattern: /(^|[()\[\]\s])#(?:[ft]|false|true)(?=[()\[\]\s]|$)/,
			lookbehind: true
		},
		'function': {
			pattern: /((?:^|[^'`#])[(\[])(?:[^|()\[\]'\s]+|\|(?:[^\\|]|\\.)*\|)(?=[()\[\]\s]|$)/,
			lookbehind: true
		},
		'identifier': {
			pattern: /(^|[()\[\]\s])\|(?:[^\\|]|\\.)*\|(?=[()\[\]\s]|$)/,
			lookbehind: true,
			greedy: true
		},
		'punctuation': /[()\[\]']/
	};

	/**
	 * Given a topologically sorted BNF grammar, this will return the RegExp source of last rule of the grammar.
	 *
	 * @param {Record<string, string>} grammar
	 * @returns {string}
	 */
	function SortedBNF(grammar) {
		for (var key in grammar) {
			grammar[key] = grammar[key].replace(/<[\w\s]+>/g, function (key) {
				return '(?:' + grammar[key].trim() + ')';
			});
		}
		// return the last item
		return grammar[key];
	}

}(Prism));

(function (Prism) {

	// CAREFUL!
	// The following patterns are concatenated, so the group referenced by a back reference is non-obvious!

	var strings = [
		// normal string
		/"(?:\\[\s\S]|\$\([^)]+\)|\$(?!\()|`[^`]+`|[^"\\`$])*"/.source,
		/'[^']*'/.source,
		/\$'(?:[^'\\]|\\[\s\S])*'/.source,

		// here doc
		// 2 capturing groups
		/<<-?\s*(["']?)(\w+)\1\s[\s\S]*?[\r\n]\2/.source
	].join('|');

	Prism.languages['shell-session'] = {
		'command': {
			pattern: RegExp(
				// user info
				/^/.source +
				'(?:' +
				(
					// <user> ":" ( <path> )?
					/[^\s@:$#%*!/\\]+@[^\r\n@:$#%*!/\\]+(?::[^\0-\x1F$#%*?"<>:;|]+)?/.source +
					'|' +
					// <path>
					// Since the path pattern is quite general, we will require it to start with a special character to
					// prevent false positives.
					/[/~.][^\0-\x1F$#%*?"<>@:;|]*/.source
				) +
				')?' +
				// shell symbol
				/[$#%](?=\s)/.source +
				// bash command
				/(?:[^\\\r\n \t'"<$]|[ \t](?:(?!#)|#.*$)|\\(?:[^\r]|\r\n?)|\$(?!')|<(?!<)|<<str>>)+/.source.replace(/<<str>>/g, function () { return strings; }),
				'm'
			),
			greedy: true,
			inside: {
				'info': {
					// foo@bar:~/files$ exit
					// foo@bar$ exit
					// ~/files$ exit
					pattern: /^[^#$%]+/,
					alias: 'punctuation',
					inside: {
						'user': /^[^\s@:$#%*!/\\]+@[^\r\n@:$#%*!/\\]+/,
						'punctuation': /:/,
						'path': /[\s\S]+/
					}
				},
				'bash': {
					pattern: /(^[$#%]\s*)\S[\s\S]*/,
					lookbehind: true,
					alias: 'language-bash',
					inside: Prism.languages.bash
				},
				'shell-symbol': {
					pattern: /^[$#%]/,
					alias: 'important'
				}
			}
		},
		'output': /.(?:.*(?:[\r\n]|.$))*/
	};

	Prism.languages['sh-session'] = Prism.languages['shellsession'] = Prism.languages['shell-session'];

}(Prism));

Prism.languages.smalltalk = {
	'comment': {
		pattern: /"(?:""|[^"])*"/,
		greedy: true
	},
	'char': {
		pattern: /\$./,
		greedy: true
	},
	'string': {
		pattern: /'(?:''|[^'])*'/,
		greedy: true
	},
	'symbol': /#[\da-z]+|#(?:-|([+\/\\*~<>=@%|&?!])\1?)|#(?=\()/i,
	'block-arguments': {
		pattern: /(\[\s*):[^\[|]*\|/,
		lookbehind: true,
		inside: {
			'variable': /:[\da-z]+/i,
			'punctuation': /\|/
		}
	},
	'temporary-variables': {
		pattern: /\|[^|]+\|/,
		inside: {
			'variable': /[\da-z]+/i,
			'punctuation': /\|/
		}
	},
	'keyword': /\b(?:new|nil|self|super)\b/,
	'boolean': /\b(?:false|true)\b/,
	'number': [
		/\d+r-?[\dA-Z]+(?:\.[\dA-Z]+)?(?:e-?\d+)?/,
		/\b\d+(?:\.\d+)?(?:e-?\d+)?/
	],
	'operator': /[<=]=?|:=|~[~=]|\/\/?|\\\\|>[>=]?|[!^+\-*&|,@]/,
	'punctuation': /[.;:?\[\](){}]/
};

(function (Prism) {

	Prism.languages.smarty = {
		'comment': {
			pattern: /^\{\*[\s\S]*?\*\}/,
			greedy: true
		},
		'embedded-php': {
			pattern: /^\{php\}[\s\S]*?\{\/php\}/,
			greedy: true,
			inside: {
				'smarty': {
					pattern: /^\{php\}|\{\/php\}$/,
					inside: null // see below
				},
				'php': {
					pattern: /[\s\S]+/,
					alias: 'language-php',
					inside: Prism.languages.php
				}
			}
		},
		'string': [
			{
				pattern: /"(?:\\.|[^"\\\r\n])*"/,
				greedy: true,
				inside: {
					'interpolation': {
						pattern: /\{[^{}]*\}|`[^`]*`/,
						inside: {
							'interpolation-punctuation': {
								pattern: /^[{`]|[`}]$/,
								alias: 'punctuation'
							},
							'expression': {
								pattern: /[\s\S]+/,
								inside: null // see below
							}
						}
					},
					'variable': /\$\w+/
				}
			},
			{
				pattern: /'(?:\\.|[^'\\\r\n])*'/,
				greedy: true
			},
		],
		'keyword': {
			pattern: /(^\{\/?)[a-z_]\w*\b(?!\()/i,
			lookbehind: true,
			greedy: true
		},
		'delimiter': {
			pattern: /^\{\/?|\}$/,
			greedy: true,
			alias: 'punctuation'
		},
		'number': /\b0x[\dA-Fa-f]+|(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:[Ee][-+]?\d+)?/,
		'variable': [
			/\$(?!\d)\w+/,
			/#(?!\d)\w+#/,
			{
				pattern: /(\.|->|\w\s*=)(?!\d)\w+\b(?!\()/,
				lookbehind: true
			},
			{
				pattern: /(\[)(?!\d)\w+(?=\])/,
				lookbehind: true
			}
		],
		'function': {
			pattern: /(\|\s*)@?[a-z_]\w*|\b[a-z_]\w*(?=\()/i,
			lookbehind: true
		},
		'attr-name': /\b[a-z_]\w*(?=\s*=)/i,
		'boolean': /\b(?:false|no|off|on|true|yes)\b/,
		'punctuation': /[\[\](){}.,:`]|->/,
		'operator': [
			/[+\-*\/%]|==?=?|[!<>]=?|&&|\|\|?/,
			/\bis\s+(?:not\s+)?(?:div|even|odd)(?:\s+by)?\b/,
			/\b(?:and|eq|gt?e|gt|lt?e|lt|mod|neq?|not|or)\b/
		]
	};

	Prism.languages.smarty['embedded-php'].inside.smarty.inside = Prism.languages.smarty;
	Prism.languages.smarty.string[0].inside.interpolation.inside.expression.inside = Prism.languages.smarty;

	var string = /"(?:\\.|[^"\\\r\n])*"|'(?:\\.|[^'\\\r\n])*'/;
	var smartyPattern = RegExp(
		// comments
		/\{\*[\s\S]*?\*\}/.source +
		'|' +
		// php tags
		/\{php\}[\s\S]*?\{\/php\}/.source +
		'|' +
		// smarty blocks
		/\{(?:[^{}"']|<str>|\{(?:[^{}"']|<str>|\{(?:[^{}"']|<str>)*\})*\})*\}/.source
			.replace(/<str>/g, function () { return string.source; }),
		'g'
	);

	// Tokenize all inline Smarty expressions
	Prism.hooks.add('before-tokenize', function (env) {
		var smartyLiteralStart = '{literal}';
		var smartyLiteralEnd = '{/literal}';
		var smartyLiteralMode = false;

		Prism.languages['markup-templating'].buildPlaceholders(env, 'smarty', smartyPattern, function (match) {
			// Smarty tags inside {literal} block are ignored
			if (match === smartyLiteralEnd) {
				smartyLiteralMode = false;
			}

			if (!smartyLiteralMode) {
				if (match === smartyLiteralStart) {
					smartyLiteralMode = true;
				}

				return true;
			}
			return false;
		});
	});

	// Re-insert the tokens after tokenizing
	Prism.hooks.add('after-tokenize', function (env) {
		Prism.languages['markup-templating'].tokenizePlaceholders(env, 'smarty');
	});

}(Prism));

// https://smlfamily.github.io/sml97-defn.pdf
// https://people.mpi-sws.org/~rossberg/sml.html
(function (Prism) {

	var keywords = /\b(?:abstype|and|andalso|as|case|datatype|do|else|end|eqtype|exception|fn|fun|functor|handle|if|in|include|infix|infixr|let|local|nonfix|of|op|open|orelse|raise|rec|sharing|sig|signature|struct|structure|then|type|val|where|while|with|withtype)\b/i;

	Prism.languages.sml = {
		// allow one level of nesting
		'comment': /\(\*(?:[^*(]|\*(?!\))|\((?!\*)|\(\*(?:[^*(]|\*(?!\))|\((?!\*))*\*\))*\*\)/,
		'string': {
			pattern: /#?"(?:[^"\\]|\\.)*"/,
			greedy: true
		},

		'class-name': [
			{
				// This is only an approximation since the real grammar is context-free
				//
				// Why the main loop so complex?
				// The main loop is approximately the same as /(?:\s*(?:[*,]|->)\s*<TERMINAL>)*/ which is, obviously, a lot
				// simpler. The difference is that if a comma is the last iteration of the loop, then the terminal must be
				// followed by a long identifier.
				pattern: RegExp(
					/((?:^|[^:]):\s*)<TERMINAL>(?:\s*(?:(?:\*|->)\s*<TERMINAL>|,\s*<TERMINAL>(?:(?=<NOT-LAST>)|(?!<NOT-LAST>)\s+<LONG-ID>)))*/.source
						.replace(/<NOT-LAST>/g, function () { return /\s*(?:[*,]|->)/.source; })
						.replace(/<TERMINAL>/g, function () {
							return /(?:'[\w']*|<LONG-ID>|\((?:[^()]|\([^()]*\))*\)|\{(?:[^{}]|\{[^{}]*\})*\})(?:\s+<LONG-ID>)*/.source;
						})
						.replace(/<LONG-ID>/g, function () { return /(?!<KEYWORD>)[a-z\d_][\w'.]*/.source; })
						.replace(/<KEYWORD>/g, function () { return keywords.source; }),
					'i'
				),
				lookbehind: true,
				greedy: true,
				inside: null // see below
			},
			{
				pattern: /((?:^|[^\w'])(?:datatype|exception|functor|signature|structure|type)\s+)[a-z_][\w'.]*/i,
				lookbehind: true
			}
		],
		'function': {
			pattern: /((?:^|[^\w'])fun\s+)[a-z_][\w'.]*/i,
			lookbehind: true
		},

		'keyword': keywords,
		'variable': {
			pattern: /(^|[^\w'])'[\w']*/,
			lookbehind: true,
		},

		'number': /~?\b(?:\d+(?:\.\d+)?(?:e~?\d+)?|0x[\da-f]+)\b/i,
		'word': {
			pattern: /\b0w(?:\d+|x[\da-f]+)\b/i,
			alias: 'constant'
		},

		'boolean': /\b(?:false|true)\b/i,
		'operator': /\.\.\.|:[>=:]|=>?|->|[<>]=?|[!+\-*/^#|@~]/,
		'punctuation': /[(){}\[\].:,;]/
	};

	Prism.languages.sml['class-name'][0].inside = Prism.languages.sml;

	Prism.languages.smlnj = Prism.languages.sml;

}(Prism));

Prism.languages.swift = {
	'comment': {
		// Nested comments are supported up to 2 levels
		pattern: /(^|[^\\:])(?:\/\/.*|\/\*(?:[^/*]|\/(?!\*)|\*(?!\/)|\/\*(?:[^*]|\*(?!\/))*\*\/)*\*\/)/,
		lookbehind: true,
		greedy: true
	},
	'string-literal': [
		// https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html
		{
			pattern: RegExp(
				/(^|[^"#])/.source
				+ '(?:'
				// single-line string
				+ /"(?:\\(?:\((?:[^()]|\([^()]*\))*\)|\r\n|[^(])|[^\\\r\n"])*"/.source
				+ '|'
				// multi-line string
				+ /"""(?:\\(?:\((?:[^()]|\([^()]*\))*\)|[^(])|[^\\"]|"(?!""))*"""/.source
				+ ')'
				+ /(?!["#])/.source
			),
			lookbehind: true,
			greedy: true,
			inside: {
				'interpolation': {
					pattern: /(\\\()(?:[^()]|\([^()]*\))*(?=\))/,
					lookbehind: true,
					inside: null // see below
				},
				'interpolation-punctuation': {
					pattern: /^\)|\\\($/,
					alias: 'punctuation'
				},
				'punctuation': /\\(?=[\r\n])/,
				'string': /[\s\S]+/
			}
		},
		{
			pattern: RegExp(
				/(^|[^"#])(#+)/.source
				+ '(?:'
				// single-line string
				+ /"(?:\\(?:#+\((?:[^()]|\([^()]*\))*\)|\r\n|[^#])|[^\\\r\n])*?"/.source
				+ '|'
				// multi-line string
				+ /"""(?:\\(?:#+\((?:[^()]|\([^()]*\))*\)|[^#])|[^\\])*?"""/.source
				+ ')'
				+ '\\2'
			),
			lookbehind: true,
			greedy: true,
			inside: {
				'interpolation': {
					pattern: /(\\#+\()(?:[^()]|\([^()]*\))*(?=\))/,
					lookbehind: true,
					inside: null // see below
				},
				'interpolation-punctuation': {
					pattern: /^\)|\\#+\($/,
					alias: 'punctuation'
				},
				'string': /[\s\S]+/
			}
		},
	],

	'directive': {
		// directives with conditions
		pattern: RegExp(
			/#/.source
			+ '(?:'
			+ (
				/(?:elseif|if)\b/.source
				+ '(?:[ \t]*'
				// This regex is a little complex. It's equivalent to this:
				//   (?:![ \t]*)?(?:\b\w+\b(?:[ \t]*<round>)?|<round>)(?:[ \t]*(?:&&|\|\|))?
				// where <round> is a general parentheses expression.
				+ /(?:![ \t]*)?(?:\b\w+\b(?:[ \t]*\((?:[^()]|\([^()]*\))*\))?|\((?:[^()]|\([^()]*\))*\))(?:[ \t]*(?:&&|\|\|))?/.source
				+ ')+'
			)
			+ '|'
			+ /(?:else|endif)\b/.source
			+ ')'
		),
		alias: 'property',
		inside: {
			'directive-name': /^#\w+/,
			'boolean': /\b(?:false|true)\b/,
			'number': /\b\d+(?:\.\d+)*\b/,
			'operator': /!|&&|\|\||[<>]=?/,
			'punctuation': /[(),]/
		}
	},
	'literal': {
		pattern: /#(?:colorLiteral|column|dsohandle|file(?:ID|Literal|Path)?|function|imageLiteral|line)\b/,
		alias: 'constant'
	},
	'other-directive': {
		pattern: /#\w+\b/,
		alias: 'property'
	},

	'attribute': {
		pattern: /@\w+/,
		alias: 'atrule'
	},

	'function-definition': {
		pattern: /(\bfunc\s+)\w+/,
		lookbehind: true,
		alias: 'function'
	},
	'label': {
		// https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html#ID141
		pattern: /\b(break|continue)\s+\w+|\b[a-zA-Z_]\w*(?=\s*:\s*(?:for|repeat|while)\b)/,
		lookbehind: true,
		alias: 'important'
	},

	'keyword': /\b(?:Any|Protocol|Self|Type|actor|as|assignment|associatedtype|associativity|async|await|break|case|catch|class|continue|convenience|default|defer|deinit|didSet|do|dynamic|else|enum|extension|fallthrough|fileprivate|final|for|func|get|guard|higherThan|if|import|in|indirect|infix|init|inout|internal|is|isolated|lazy|left|let|lowerThan|mutating|none|nonisolated|nonmutating|open|operator|optional|override|postfix|precedencegroup|prefix|private|protocol|public|repeat|required|rethrows|return|right|safe|self|set|some|static|struct|subscript|super|switch|throw|throws|try|typealias|unowned|unsafe|var|weak|where|while|willSet)\b/,
	'boolean': /\b(?:false|true)\b/,
	'nil': {
		pattern: /\bnil\b/,
		alias: 'constant'
	},

	'short-argument': /\$\d+\b/,
	'omit': {
		pattern: /\b_\b/,
		alias: 'keyword'
	},
	'number': /\b(?:[\d_]+(?:\.[\de_]+)?|0x[a-f0-9_]+(?:\.[a-f0-9p_]+)?|0b[01_]+|0o[0-7_]+)\b/i,

	// A class name must start with an upper-case letter and be either 1 letter long or contain a lower-case letter.
	'class-name': /\b[A-Z](?:[A-Z_\d]*[a-z]\w*)?\b/,
	'function': /\b[a-z_]\w*(?=\s*\()/i,
	'constant': /\b(?:[A-Z_]{2,}|k[A-Z][A-Za-z_]+)\b/,

	// Operators are generic in Swift. Developers can even create new operators (e.g. +++).
	// https://docs.swift.org/swift-book/ReferenceManual/zzSummaryOfTheGrammar.html#ID481
	// This regex only supports ASCII operators.
	'operator': /[-+*/%=!<>&|^~?]+|\.[.\-+*/%=!<>&|^~?]+/,
	'punctuation': /[{}[\]();,.:\\]/
};

Prism.languages.swift['string-literal'].forEach(function (rule) {
	rule.inside['interpolation'].inside = Prism.languages.swift;
});

// https://www.freedesktop.org/software/systemd/man/systemd.syntax.html

(function (Prism) {

	var comment = {
		pattern: /^[;#].*/m,
		greedy: true
	};

	var quotesSource = /"(?:[^\r\n"\\]|\\(?:[^\r]|\r\n?))*"(?!\S)/.source;

	Prism.languages.systemd = {
		'comment': comment,

		'section': {
			pattern: /^\[[^\n\r\[\]]*\](?=[ \t]*$)/m,
			greedy: true,
			inside: {
				'punctuation': /^\[|\]$/,
				'section-name': {
					pattern: /[\s\S]+/,
					alias: 'selector'
				},
			}
		},

		'key': {
			pattern: /^[^\s=]+(?=[ \t]*=)/m,
			greedy: true,
			alias: 'attr-name'
		},
		'value': {
			// This pattern is quite complex because of two properties:
			//  1) Quotes (strings) must be preceded by a space. Since we can't use lookbehinds, we have to "resolve"
			//     the lookbehind. You will see this in the main loop where spaces are handled separately.
			//  2) Line continuations.
			//     After line continuations, empty lines and comments are ignored so we have to consume them.
			pattern: RegExp(
				/(=[ \t]*(?!\s))/.source +
				// the value either starts with quotes or not
				'(?:' + quotesSource + '|(?=[^"\r\n]))' +
				// main loop
				'(?:' + (
					/[^\s\\]/.source +
					// handle spaces separately because of quotes
					'|' + '[ \t]+(?:(?![ \t"])|' + quotesSource + ')' +
					// line continuation
					'|' + /\\[\r\n]+(?:[#;].*[\r\n]+)*(?![#;])/.source
				) +
				')*'
			),
			lookbehind: true,
			greedy: true,
			alias: 'attr-value',
			inside: {
				'comment': comment,
				'quoted': {
					pattern: RegExp(/(^|\s)/.source + quotesSource),
					lookbehind: true,
					greedy: true,
				},
				'punctuation': /\\$/m,

				'boolean': {
					pattern: /^(?:false|no|off|on|true|yes)$/,
					greedy: true
				}
			}
		},

		'punctuation': /=/
	};

}(Prism));

Prism.languages.tcl = {
	'comment': {
		pattern: /(^|[^\\])#.*/,
		lookbehind: true
	},
	'string': {
		pattern: /"(?:[^"\\\r\n]|\\(?:\r\n|[\s\S]))*"/,
		greedy: true
	},
	'variable': [
		{
			pattern: /(\$)(?:::)?(?:[a-zA-Z0-9]+::)*\w+/,
			lookbehind: true
		},
		{
			pattern: /(\$)\{[^}]+\}/,
			lookbehind: true
		},
		{
			pattern: /(^[\t ]*set[ \t]+)(?:::)?(?:[a-zA-Z0-9]+::)*\w+/m,
			lookbehind: true
		}
	],
	'function': {
		pattern: /(^[\t ]*proc[ \t]+)\S+/m,
		lookbehind: true
	},
	'builtin': [
		{
			pattern: /(^[\t ]*)(?:break|class|continue|error|eval|exit|for|foreach|if|proc|return|switch|while)\b/m,
			lookbehind: true
		},
		/\b(?:else|elseif)\b/
	],
	'scope': {
		pattern: /(^[\t ]*)(?:global|upvar|variable)\b/m,
		lookbehind: true,
		alias: 'constant'
	},
	'keyword': {
		pattern: /(^[\t ]*|\[)(?:Safe_Base|Tcl|after|append|apply|array|auto_(?:execok|import|load|mkindex|qualify|reset)|automkindex_old|bgerror|binary|catch|cd|chan|clock|close|concat|dde|dict|encoding|eof|exec|expr|fblocked|fconfigure|fcopy|file(?:event|name)?|flush|gets|glob|history|http|incr|info|interp|join|lappend|lassign|lindex|linsert|list|llength|load|lrange|lrepeat|lreplace|lreverse|lsearch|lset|lsort|math(?:func|op)|memory|msgcat|namespace|open|package|parray|pid|pkg_mkIndex|platform|puts|pwd|re_syntax|read|refchan|regexp|registry|regsub|rename|scan|seek|set|socket|source|split|string|subst|tcl(?:_endOfWord|_findLibrary|startOf(?:Next|Previous)Word|test|vars|wordBreak(?:After|Before))|tell|time|tm|trace|unknown|unload|unset|update|uplevel|vwait)\b/m,
		lookbehind: true
	},
	'operator': /!=?|\*\*?|==|&&?|\|\|?|<[=<]?|>[=>]?|[-+~\/%?^]|\b(?:eq|in|ne|ni)\b/,
	'punctuation': /[{}()\[\]]/
};

(function (Prism) {

	var keywords = /\b(?:ACT|ACTIFSUB|CARRAY|CASE|CLEARGIF|COA|COA_INT|CONSTANTS|CONTENT|CUR|EDITPANEL|EFFECT|EXT|FILE|FLUIDTEMPLATE|FORM|FRAME|FRAMESET|GIFBUILDER|GMENU|GMENU_FOLDOUT|GMENU_LAYERS|GP|HMENU|HRULER|HTML|IENV|IFSUB|IMAGE|IMGMENU|IMGMENUITEM|IMGTEXT|IMG_RESOURCE|INCLUDE_TYPOSCRIPT|JSMENU|JSMENUITEM|LLL|LOAD_REGISTER|NO|PAGE|RECORDS|RESTORE_REGISTER|TEMPLATE|TEXT|TMENU|TMENUITEM|TMENU_LAYERS|USER|USER_INT|_GIFBUILDER|global|globalString|globalVar)\b/;

	Prism.languages.typoscript = {
		'comment': [
			{
				// multiline comments /* */
				pattern: /(^|[^\\])\/\*[\s\S]*?(?:\*\/|$)/,
				lookbehind: true
			},
			{
				// double-slash comments - ignored when backslashes or colon is found in front
				// also ignored whenever directly after an equal-sign, because it would probably be an url without protocol
				pattern: /(^|[^\\:= \t]|(?:^|[^= \t])[ \t]+)\/\/.*/,
				lookbehind: true,
				greedy: true
			},
			{
				// hash comments - ignored when leading quote is found for hex colors in strings
				pattern: /(^|[^"'])#.*/,
				lookbehind: true,
				greedy: true
			}
		],
		'function': [
			{
				// old include style
				pattern: /<INCLUDE_TYPOSCRIPT:\s*source\s*=\s*(?:"[^"\r\n]*"|'[^'\r\n]*')\s*>/,
				inside: {
					'string': {
						pattern: /"[^"\r\n]*"|'[^'\r\n]*'/,
						inside: {
							'keyword': keywords,
						},
					},
					'keyword': {
						pattern: /INCLUDE_TYPOSCRIPT/,
					},
				},
			},
			{
				// new include style
				pattern: /@import\s*(?:"[^"\r\n]*"|'[^'\r\n]*')/,
				inside: {
					'string': /"[^"\r\n]*"|'[^'\r\n]*'/,
				},
			}
		],
		'string': {
			pattern: /^([^=]*=[< ]?)(?:(?!\]\n).)*/,
			lookbehind: true,
			inside: {
				'function': /\{\$.*\}/, // constants include
				'keyword': keywords,
				'number': /^\d+$/,
				'punctuation': /[,|:]/,
			}
		},
		'keyword': keywords,
		'number': {
			// special highlighting for indexes of arrays in tags
			pattern: /\b\d+\s*[.{=]/,
			inside: {
				'operator': /[.{=]/,
			}
		},
		'tag': {
			pattern: /\.?[-\w\\]+\.?/,
			inside: {
				'punctuation': /\./,
			}
		},
		'punctuation': /[{}[\];(),.:|]/,
		'operator': /[<>]=?|[!=]=?=?|--?|\+\+?|&&?|\|\|?|[?*/~^%]/,
	};

	Prism.languages.tsconfig = Prism.languages.typoscript;

}(Prism));

Prism.languages.unrealscript = {
	'comment': /\/\/.*|\/\*[\s\S]*?\*\//,
	'string': {
		pattern: /(["'])(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1/,
		greedy: true
	},
	'category': {
		pattern: /(\b(?:(?:autoexpand|hide|show)categories|var)\s*\()[^()]+(?=\))/,
		lookbehind: true,
		greedy: true,
		alias: 'property'
	},
	'metadata': {
		pattern: /(\w\s*)<\s*\w+\s*=[^<>|=\r\n]+(?:\|\s*\w+\s*=[^<>|=\r\n]+)*>/,
		lookbehind: true,
		greedy: true,
		inside: {
			'property': /\b\w+(?=\s*=)/,
			'operator': /=/,
			'punctuation': /[<>|]/
		}
	},
	'macro': {
		pattern: /`\w+/,
		alias: 'property'
	},
	'class-name': {
		pattern: /(\b(?:class|enum|extends|interface|state(?:\(\))?|struct|within)\s+)\w+/,
		lookbehind: true
	},

	'keyword': /\b(?:abstract|actor|array|auto|autoexpandcategories|bool|break|byte|case|class|classgroup|client|coerce|collapsecategories|config|const|continue|default|defaultproperties|delegate|dependson|deprecated|do|dontcollapsecategories|editconst|editinlinenew|else|enum|event|exec|export|extends|final|float|for|forcescriptorder|foreach|function|goto|guid|hidecategories|hidedropdown|if|ignores|implements|inherits|input|int|interface|iterator|latent|local|material|name|native|nativereplication|noexport|nontransient|noteditinlinenew|notplaceable|operator|optional|out|pawn|perobjectconfig|perobjectlocalized|placeable|postoperator|preoperator|private|protected|reliable|replication|return|server|showcategories|simulated|singular|state|static|string|struct|structdefault|structdefaultproperties|switch|texture|transient|travel|unreliable|until|var|vector|while|within)\b/,
	'function': /\b[a-z_]\w*(?=\s*\()/i,

	'boolean': /\b(?:false|true)\b/,
	'number': /\b0x[\da-f]+\b|(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:e[+-]?\d+)?/i,
	// https://docs.unrealengine.com/udk/Three/UnrealScriptExpressions.html
	'operator': />>|<<|--|\+\+|\*\*|[-+*/~!=<>$@]=?|&&?|\|\|?|\^\^?|[?:%]|\b(?:ClockwiseFrom|Cross|Dot)\b/,
	'punctuation': /[()[\]{};,.]/
};

Prism.languages.uc = Prism.languages.uscript = Prism.languages.unrealscript;

(function (Prism) {
	Prism.languages.velocity = Prism.languages.extend('markup', {});

	var velocity = {
		'variable': {
			pattern: /(^|[^\\](?:\\\\)*)\$!?(?:[a-z][\w-]*(?:\([^)]*\))?(?:\.[a-z][\w-]*(?:\([^)]*\))?|\[[^\]]+\])*|\{[^}]+\})/i,
			lookbehind: true,
			inside: {} // See below
		},
		'string': {
			pattern: /"[^"]*"|'[^']*'/,
			greedy: true
		},
		'number': /\b\d+\b/,
		'boolean': /\b(?:false|true)\b/,
		'operator': /[=!<>]=?|[+*/%-]|&&|\|\||\.\.|\b(?:eq|g[et]|l[et]|n(?:e|ot))\b/,
		'punctuation': /[(){}[\]:,.]/
	};

	velocity.variable.inside = {
		'string': velocity['string'],
		'function': {
			pattern: /([^\w-])[a-z][\w-]*(?=\()/,
			lookbehind: true
		},
		'number': velocity['number'],
		'boolean': velocity['boolean'],
		'punctuation': velocity['punctuation']
	};

	Prism.languages.insertBefore('velocity', 'comment', {
		'unparsed': {
			pattern: /(^|[^\\])#\[\[[\s\S]*?\]\]#/,
			lookbehind: true,
			greedy: true,
			inside: {
				'punctuation': /^#\[\[|\]\]#$/
			}
		},
		'velocity-comment': [
			{
				pattern: /(^|[^\\])#\*[\s\S]*?\*#/,
				lookbehind: true,
				greedy: true,
				alias: 'comment'
			},
			{
				pattern: /(^|[^\\])##.*/,
				lookbehind: true,
				greedy: true,
				alias: 'comment'
			}
		],
		'directive': {
			pattern: /(^|[^\\](?:\\\\)*)#@?(?:[a-z][\w-]*|\{[a-z][\w-]*\})(?:\s*\((?:[^()]|\([^()]*\))*\))?/i,
			lookbehind: true,
			inside: {
				'keyword': {
					pattern: /^#@?(?:[a-z][\w-]*|\{[a-z][\w-]*\})|\bin\b/,
					inside: {
						'punctuation': /[{}]/
					}
				},
				rest: velocity
			}
		},
		'variable': velocity['variable']
	});

	Prism.languages.velocity['tag'].inside['attr-value'].inside.rest = Prism.languages.velocity;

}(Prism));

Prism.languages.vim = {
	'string': /"(?:[^"\\\r\n]|\\.)*"|'(?:[^'\r\n]|'')*'/,
	'comment': /".*/,
	'function': /\b\w+(?=\()/,
	'keyword': /\b(?:N|Next|P|Print|X|XMLent|XMLns|ab|abbreviate|abc|abclear|abo|aboveleft|al|all|ar|arga|argadd|argd|argdelete|argdo|arge|argedit|argg|argglobal|argl|arglocal|args|argu|argument|as|ascii|b|bN|bNext|ba|bad|badd|ball|bd|bdelete|be|bel|belowright|bf|bfirst|bl|blast|bm|bmodified|bn|bnext|bo|botright|bp|bprevious|br|brea|break|breaka|breakadd|breakd|breakdel|breakl|breaklist|brewind|bro|browse|bufdo|buffer|buffers|bun|bunload|bw|bwipeout|c|cN|cNext|cNfcNfile|ca|cabbrev|cabc|cabclear|cad|caddb|caddbuffer|caddexpr|caddf|caddfile|cal|call|cat|catch|cb|cbuffer|cc|ccl|cclose|cd|ce|center|cex|cexpr|cf|cfile|cfir|cfirst|cg|cgetb|cgetbuffer|cgete|cgetexpr|cgetfile|change|changes|chd|chdir|che|checkpath|checkt|checktime|cl|cla|clast|clist|clo|close|cmapc|cmapclear|cn|cnew|cnewer|cnext|cnf|cnfile|cnorea|cnoreabbrev|co|col|colder|colo|colorscheme|comc|comclear|comp|compiler|con|conf|confirm|continue|cope|copen|copy|cp|cpf|cpfile|cprevious|cq|cquit|cr|crewind|cu|cuna|cunabbrev|cunmap|cw|cwindow|d|debugg|debuggreedy|delc|delcommand|delete|delf|delfunction|delm|delmarks|di|diffg|diffget|diffoff|diffpatch|diffpu|diffput|diffsplit|diffthis|diffu|diffupdate|dig|digraphs|display|dj|djump|dl|dlist|dr|drop|ds|dsearch|dsp|dsplit|e|earlier|echoe|echoerr|echom|echomsg|echon|edit|el|else|elsei|elseif|em|emenu|en|endf|endfo|endfor|endfun|endfunction|endif|endt|endtry|endw|endwhile|ene|enew|ex|exi|exit|exu|exusage|f|file|files|filetype|fin|fina|finally|find|fini|finish|fir|first|fix|fixdel|fo|fold|foldc|foldclose|foldd|folddoc|folddoclosed|folddoopen|foldo|foldopen|for|fu|fun|function|go|goto|gr|grep|grepa|grepadd|h|ha|hardcopy|help|helpf|helpfind|helpg|helpgrep|helpt|helptags|hid|hide|his|history|ia|iabbrev|iabc|iabclear|if|ij|ijump|il|ilist|imapc|imapclear|in|inorea|inoreabbrev|isearch|isp|isplit|iu|iuna|iunabbrev|iunmap|j|join|ju|jumps|k|kee|keepalt|keepj|keepjumps|keepmarks|l|lN|lNext|lNf|lNfile|la|lad|laddb|laddbuffer|laddexpr|laddf|laddfile|lan|language|last|later|lb|lbuffer|lc|lcd|lch|lchdir|lcl|lclose|left|lefta|leftabove|let|lex|lexpr|lf|lfile|lfir|lfirst|lg|lgetb|lgetbuffer|lgete|lgetexpr|lgetfile|lgr|lgrep|lgrepa|lgrepadd|lh|lhelpgrep|list|ll|lla|llast|lli|llist|lm|lmak|lmake|lmap|lmapc|lmapclear|ln|lne|lnew|lnewer|lnext|lnf|lnfile|lnoremap|lo|loadview|loc|lockmarks|lockv|lockvar|lol|lolder|lop|lopen|lp|lpf|lpfile|lprevious|lr|lrewind|ls|lt|ltag|lu|lunmap|lv|lvimgrep|lvimgrepa|lvimgrepadd|lw|lwindow|m|ma|mak|make|mark|marks|mat|match|menut|menutranslate|mk|mkexrc|mks|mksession|mksp|mkspell|mkv|mkvie|mkview|mkvimrc|mod|mode|move|mz|mzf|mzfile|mzscheme|n|nbkey|new|next|nmapc|nmapclear|noh|nohlsearch|norea|noreabbrev|nu|number|nun|nunmap|o|omapc|omapclear|on|only|open|opt|options|ou|ounmap|p|pc|pclose|pe|ped|pedit|perl|perld|perldo|po|pop|popu|popup|pp|ppop|pre|preserve|prev|previous|print|prof|profd|profdel|profile|promptf|promptfind|promptr|promptrepl|ps|psearch|ptN|ptNext|pta|ptag|ptf|ptfirst|ptj|ptjump|ptl|ptlast|ptn|ptnext|ptp|ptprevious|ptr|ptrewind|pts|ptselect|pu|put|pw|pwd|py|pyf|pyfile|python|q|qa|qall|quit|quita|quitall|r|read|rec|recover|red|redi|redir|redo|redr|redraw|redraws|redrawstatus|reg|registers|res|resize|ret|retab|retu|return|rew|rewind|ri|right|rightb|rightbelow|ru|rub|ruby|rubyd|rubydo|rubyf|rubyfile|runtime|rv|rviminfo|sN|sNext|sa|sal|sall|san|sandbox|sargument|sav|saveas|sb|sbN|sbNext|sba|sball|sbf|sbfirst|sbl|sblast|sbm|sbmodified|sbn|sbnext|sbp|sbprevious|sbr|sbrewind|sbuffer|scrip|scripte|scriptencoding|scriptnames|se|set|setf|setfiletype|setg|setglobal|setl|setlocal|sf|sfind|sfir|sfirst|sh|shell|sign|sil|silent|sim|simalt|sl|sla|slast|sleep|sm|smagic|smap|smapc|smapclear|sme|smenu|sn|snext|sni|sniff|sno|snomagic|snor|snoremap|snoreme|snoremenu|so|sor|sort|source|sp|spe|spelld|spelldump|spellgood|spelli|spellinfo|spellr|spellrepall|spellu|spellundo|spellw|spellwrong|split|spr|sprevious|sre|srewind|st|sta|stag|star|startg|startgreplace|startinsert|startr|startreplace|stj|stjump|stop|stopi|stopinsert|sts|stselect|sun|sunhide|sunm|sunmap|sus|suspend|sv|sview|syncbind|t|tN|tNext|ta|tab|tabN|tabNext|tabc|tabclose|tabd|tabdo|tabe|tabedit|tabf|tabfind|tabfir|tabfirst|tabl|tablast|tabm|tabmove|tabn|tabnew|tabnext|tabo|tabonly|tabp|tabprevious|tabr|tabrewind|tabs|tag|tags|tc|tcl|tcld|tcldo|tclf|tclfile|te|tearoff|tf|tfirst|th|throw|tj|tjump|tl|tlast|tm|tmenu|tn|tnext|to|topleft|tp|tprevious|tr|trewind|try|ts|tselect|tu|tunmenu|u|una|unabbreviate|undo|undoj|undojoin|undol|undolist|unh|unhide|unlet|unlo|unlockvar|unm|unmap|up|update|ve|verb|verbose|version|vert|vertical|vi|vie|view|vim|vimgrep|vimgrepa|vimgrepadd|visual|viu|viusage|vmapc|vmapclear|vne|vnew|vs|vsplit|vu|vunmap|w|wN|wNext|wa|wall|wh|while|win|winc|wincmd|windo|winp|winpos|winsize|wn|wnext|wp|wprevious|wq|wqa|wqall|write|ws|wsverb|wv|wviminfo|x|xa|xall|xit|xm|xmap|xmapc|xmapclear|xme|xmenu|xn|xnoremap|xnoreme|xnoremenu|xu|xunmap|y|yank)\b/,
	'builtin': /\b(?:acd|ai|akm|aleph|allowrevins|altkeymap|ambiwidth|ambw|anti|antialias|arab|arabic|arabicshape|ari|arshape|autochdir|autocmd|autoindent|autoread|autowrite|autowriteall|aw|awa|background|backspace|backup|backupcopy|backupdir|backupext|backupskip|balloondelay|ballooneval|balloonexpr|bdir|bdlay|beval|bex|bexpr|bg|bh|bin|binary|biosk|bioskey|bk|bkc|bomb|breakat|brk|browsedir|bs|bsdir|bsk|bt|bufhidden|buflisted|buftype|casemap|ccv|cdpath|cedit|cfu|ch|charconvert|ci|cin|cindent|cink|cinkeys|cino|cinoptions|cinw|cinwords|clipboard|cmdheight|cmdwinheight|cmp|cms|columns|com|comments|commentstring|compatible|complete|completefunc|completeopt|consk|conskey|copyindent|cot|cpo|cpoptions|cpt|cscopepathcomp|cscopeprg|cscopequickfix|cscopetag|cscopetagorder|cscopeverbose|cspc|csprg|csqf|cst|csto|csverb|cuc|cul|cursorcolumn|cursorline|cwh|debug|deco|def|define|delcombine|dex|dg|dict|dictionary|diff|diffexpr|diffopt|digraph|dip|dir|directory|dy|ea|ead|eadirection|eb|ed|edcompatible|ef|efm|ei|ek|enc|encoding|endofline|eol|ep|equalalways|equalprg|errorbells|errorfile|errorformat|esckeys|et|eventignore|expandtab|exrc|fcl|fcs|fdc|fde|fdi|fdl|fdls|fdm|fdn|fdo|fdt|fen|fenc|fencs|fex|ff|ffs|fileencoding|fileencodings|fileformat|fileformats|fillchars|fk|fkmap|flp|fml|fmr|foldcolumn|foldenable|foldexpr|foldignore|foldlevel|foldlevelstart|foldmarker|foldmethod|foldminlines|foldnestmax|foldtext|formatexpr|formatlistpat|formatoptions|formatprg|fp|fs|fsync|ft|gcr|gd|gdefault|gfm|gfn|gfs|gfw|ghr|gp|grepformat|grepprg|gtl|gtt|guicursor|guifont|guifontset|guifontwide|guiheadroom|guioptions|guipty|guitablabel|guitabtooltip|helpfile|helpheight|helplang|hf|hh|hi|hidden|highlight|hk|hkmap|hkmapp|hkp|hl|hlg|hls|hlsearch|ic|icon|iconstring|ignorecase|im|imactivatekey|imak|imc|imcmdline|imd|imdisable|imi|iminsert|ims|imsearch|inc|include|includeexpr|incsearch|inde|indentexpr|indentkeys|indk|inex|inf|infercase|insertmode|invacd|invai|invakm|invallowrevins|invaltkeymap|invanti|invantialias|invar|invarab|invarabic|invarabicshape|invari|invarshape|invautochdir|invautoindent|invautoread|invautowrite|invautowriteall|invaw|invawa|invbackup|invballooneval|invbeval|invbin|invbinary|invbiosk|invbioskey|invbk|invbl|invbomb|invbuflisted|invcf|invci|invcin|invcindent|invcompatible|invconfirm|invconsk|invconskey|invcopyindent|invcp|invcscopetag|invcscopeverbose|invcst|invcsverb|invcuc|invcul|invcursorcolumn|invcursorline|invdeco|invdelcombine|invdg|invdiff|invdigraph|invdisable|invea|inveb|inved|invedcompatible|invek|invendofline|inveol|invequalalways|inverrorbells|invesckeys|invet|invex|invexpandtab|invexrc|invfen|invfk|invfkmap|invfoldenable|invgd|invgdefault|invguipty|invhid|invhidden|invhk|invhkmap|invhkmapp|invhkp|invhls|invhlsearch|invic|invicon|invignorecase|invim|invimc|invimcmdline|invimd|invincsearch|invinf|invinfercase|invinsertmode|invis|invjoinspaces|invjs|invlazyredraw|invlbr|invlinebreak|invlisp|invlist|invloadplugins|invlpl|invlz|invma|invmacatsui|invmagic|invmh|invml|invmod|invmodeline|invmodifiable|invmodified|invmore|invmousef|invmousefocus|invmousehide|invnu|invnumber|invodev|invopendevice|invpaste|invpi|invpreserveindent|invpreviewwindow|invprompt|invpvw|invreadonly|invremap|invrestorescreen|invrevins|invri|invrightleft|invrightleftcmd|invrl|invrlc|invro|invrs|invru|invruler|invsb|invsc|invscb|invscrollbind|invscs|invsecure|invsft|invshellslash|invshelltemp|invshiftround|invshortname|invshowcmd|invshowfulltag|invshowmatch|invshowmode|invsi|invsm|invsmartcase|invsmartindent|invsmarttab|invsmd|invsn|invsol|invspell|invsplitbelow|invsplitright|invspr|invsr|invssl|invsta|invstartofline|invstmp|invswapfile|invswf|invta|invtagbsearch|invtagrelative|invtagstack|invtbi|invtbidi|invtbs|invtermbidi|invterse|invtextauto|invtextmode|invtf|invtgst|invtildeop|invtimeout|invtitle|invto|invtop|invtr|invttimeout|invttybuiltin|invttyfast|invtx|invvb|invvisualbell|invwa|invwarn|invwb|invweirdinvert|invwfh|invwfw|invwildmenu|invwinfixheight|invwinfixwidth|invwiv|invwmnu|invwrap|invwrapscan|invwrite|invwriteany|invwritebackup|invws|isf|isfname|isi|isident|isk|iskeyword|isprint|joinspaces|js|key|keymap|keymodel|keywordprg|km|kmp|kp|langmap|langmenu|laststatus|lazyredraw|lbr|lcs|linebreak|lines|linespace|lisp|lispwords|listchars|loadplugins|lpl|lsp|lz|macatsui|magic|makeef|makeprg|matchpairs|matchtime|maxcombine|maxfuncdepth|maxmapdepth|maxmem|maxmempattern|maxmemtot|mco|mef|menuitems|mfd|mh|mis|mkspellmem|ml|mls|mm|mmd|mmp|mmt|modeline|modelines|modifiable|modified|more|mouse|mousef|mousefocus|mousehide|mousem|mousemodel|mouses|mouseshape|mouset|mousetime|mp|mps|msm|mzq|mzquantum|nf|noacd|noai|noakm|noallowrevins|noaltkeymap|noanti|noantialias|noar|noarab|noarabic|noarabicshape|noari|noarshape|noautochdir|noautoindent|noautoread|noautowrite|noautowriteall|noaw|noawa|nobackup|noballooneval|nobeval|nobin|nobinary|nobiosk|nobioskey|nobk|nobl|nobomb|nobuflisted|nocf|noci|nocin|nocindent|nocompatible|noconfirm|noconsk|noconskey|nocopyindent|nocp|nocscopetag|nocscopeverbose|nocst|nocsverb|nocuc|nocul|nocursorcolumn|nocursorline|nodeco|nodelcombine|nodg|nodiff|nodigraph|nodisable|noea|noeb|noed|noedcompatible|noek|noendofline|noeol|noequalalways|noerrorbells|noesckeys|noet|noex|noexpandtab|noexrc|nofen|nofk|nofkmap|nofoldenable|nogd|nogdefault|noguipty|nohid|nohidden|nohk|nohkmap|nohkmapp|nohkp|nohls|noic|noicon|noignorecase|noim|noimc|noimcmdline|noimd|noincsearch|noinf|noinfercase|noinsertmode|nois|nojoinspaces|nojs|nolazyredraw|nolbr|nolinebreak|nolisp|nolist|noloadplugins|nolpl|nolz|noma|nomacatsui|nomagic|nomh|noml|nomod|nomodeline|nomodifiable|nomodified|nomore|nomousef|nomousefocus|nomousehide|nonu|nonumber|noodev|noopendevice|nopaste|nopi|nopreserveindent|nopreviewwindow|noprompt|nopvw|noreadonly|noremap|norestorescreen|norevins|nori|norightleft|norightleftcmd|norl|norlc|noro|nors|noru|noruler|nosb|nosc|noscb|noscrollbind|noscs|nosecure|nosft|noshellslash|noshelltemp|noshiftround|noshortname|noshowcmd|noshowfulltag|noshowmatch|noshowmode|nosi|nosm|nosmartcase|nosmartindent|nosmarttab|nosmd|nosn|nosol|nospell|nosplitbelow|nosplitright|nospr|nosr|nossl|nosta|nostartofline|nostmp|noswapfile|noswf|nota|notagbsearch|notagrelative|notagstack|notbi|notbidi|notbs|notermbidi|noterse|notextauto|notextmode|notf|notgst|notildeop|notimeout|notitle|noto|notop|notr|nottimeout|nottybuiltin|nottyfast|notx|novb|novisualbell|nowa|nowarn|nowb|noweirdinvert|nowfh|nowfw|nowildmenu|nowinfixheight|nowinfixwidth|nowiv|nowmnu|nowrap|nowrapscan|nowrite|nowriteany|nowritebackup|nows|nrformats|numberwidth|nuw|odev|oft|ofu|omnifunc|opendevice|operatorfunc|opfunc|osfiletype|pa|para|paragraphs|paste|pastetoggle|patchexpr|patchmode|path|pdev|penc|pex|pexpr|pfn|ph|pheader|pi|pm|pmbcs|pmbfn|popt|preserveindent|previewheight|previewwindow|printdevice|printencoding|printexpr|printfont|printheader|printmbcharset|printmbfont|printoptions|prompt|pt|pumheight|pvh|pvw|qe|quoteescape|readonly|remap|report|restorescreen|revins|rightleft|rightleftcmd|rl|rlc|ro|rs|rtp|ruf|ruler|rulerformat|runtimepath|sbo|sc|scb|scr|scroll|scrollbind|scrolljump|scrolloff|scrollopt|scs|sect|sections|secure|sel|selection|selectmode|sessionoptions|sft|shcf|shellcmdflag|shellpipe|shellquote|shellredir|shellslash|shelltemp|shelltype|shellxquote|shiftround|shiftwidth|shm|shortmess|shortname|showbreak|showcmd|showfulltag|showmatch|showmode|showtabline|shq|si|sidescroll|sidescrolloff|siso|sj|slm|smartcase|smartindent|smarttab|smc|smd|softtabstop|sol|spc|spell|spellcapcheck|spellfile|spelllang|spellsuggest|spf|spl|splitbelow|splitright|sps|sr|srr|ss|ssl|ssop|stal|startofline|statusline|stl|stmp|su|sua|suffixes|suffixesadd|sw|swapfile|swapsync|swb|swf|switchbuf|sws|sxq|syn|synmaxcol|syntax|t_AB|t_AF|t_AL|t_CS|t_CV|t_Ce|t_Co|t_Cs|t_DL|t_EI|t_F1|t_F2|t_F3|t_F4|t_F5|t_F6|t_F7|t_F8|t_F9|t_IE|t_IS|t_K1|t_K3|t_K4|t_K5|t_K6|t_K7|t_K8|t_K9|t_KA|t_KB|t_KC|t_KD|t_KE|t_KF|t_KG|t_KH|t_KI|t_KJ|t_KK|t_KL|t_RI|t_RV|t_SI|t_Sb|t_Sf|t_WP|t_WS|t_ZH|t_ZR|t_al|t_bc|t_cd|t_ce|t_cl|t_cm|t_cs|t_da|t_db|t_dl|t_fs|t_k1|t_k2|t_k3|t_k4|t_k5|t_k6|t_k7|t_k8|t_k9|t_kB|t_kD|t_kI|t_kN|t_kP|t_kb|t_kd|t_ke|t_kh|t_kl|t_kr|t_ks|t_ku|t_le|t_mb|t_md|t_me|t_mr|t_ms|t_nd|t_op|t_se|t_so|t_sr|t_te|t_ti|t_ts|t_ue|t_us|t_ut|t_vb|t_ve|t_vi|t_vs|t_xs|tabline|tabpagemax|tabstop|tagbsearch|taglength|tagrelative|tagstack|tal|tb|tbi|tbidi|tbis|tbs|tenc|term|termbidi|termencoding|terse|textauto|textmode|textwidth|tgst|thesaurus|tildeop|timeout|timeoutlen|title|titlelen|titleold|titlestring|toolbar|toolbariconsize|top|tpm|tsl|tsr|ttimeout|ttimeoutlen|ttm|tty|ttybuiltin|ttyfast|ttym|ttymouse|ttyscroll|ttytype|tw|tx|uc|ul|undolevels|updatecount|updatetime|ut|vb|vbs|vdir|verbosefile|vfile|viewdir|viewoptions|viminfo|virtualedit|visualbell|vop|wak|warn|wb|wc|wcm|wd|weirdinvert|wfh|wfw|whichwrap|wi|wig|wildchar|wildcharm|wildignore|wildmenu|wildmode|wildoptions|wim|winaltkeys|window|winfixheight|winfixwidth|winheight|winminheight|winminwidth|winwidth|wiv|wiw|wm|wmh|wmnu|wmw|wop|wrap|wrapmargin|wrapscan|writeany|writebackup|writedelay|ww)\b/,
	'number': /\b(?:0x[\da-f]+|\d+(?:\.\d+)?)\b/i,
	'operator': /\|\||&&|[-+.]=?|[=!](?:[=~][#?]?)?|[<>]=?[#?]?|[*\/%?]|\b(?:is(?:not)?)\b/,
	'punctuation': /[{}[\](),;:]/
};

Prism.languages.wasm = {
	'comment': [
		/\(;[\s\S]*?;\)/,
		{
			pattern: /;;.*/,
			greedy: true
		}
	],
	'string': {
		pattern: /"(?:\\[\s\S]|[^"\\])*"/,
		greedy: true
	},
	'keyword': [
		{
			pattern: /\b(?:align|offset)=/,
			inside: {
				'operator': /=/
			}
		},
		{
			pattern: /\b(?:(?:f32|f64|i32|i64)(?:\.(?:abs|add|and|ceil|clz|const|convert_[su]\/i(?:32|64)|copysign|ctz|demote\/f64|div(?:_[su])?|eqz?|extend_[su]\/i32|floor|ge(?:_[su])?|gt(?:_[su])?|le(?:_[su])?|load(?:(?:8|16|32)_[su])?|lt(?:_[su])?|max|min|mul|neg?|nearest|or|popcnt|promote\/f32|reinterpret\/[fi](?:32|64)|rem_[su]|rot[lr]|shl|shr_[su]|sqrt|store(?:8|16|32)?|sub|trunc(?:_[su]\/f(?:32|64))?|wrap\/i64|xor))?|memory\.(?:grow|size))\b/,
			inside: {
				'punctuation': /\./
			}
		},
		/\b(?:anyfunc|block|br(?:_if|_table)?|call(?:_indirect)?|data|drop|elem|else|end|export|func|get_(?:global|local)|global|if|import|local|loop|memory|module|mut|nop|offset|param|result|return|select|set_(?:global|local)|start|table|tee_local|then|type|unreachable)\b/
	],
	'variable': /\$[\w!#$%&'*+\-./:<=>?@\\^`|~]+/,
	'number': /[+-]?\b(?:\d(?:_?\d)*(?:\.\d(?:_?\d)*)?(?:[eE][+-]?\d(?:_?\d)*)?|0x[\da-fA-F](?:_?[\da-fA-F])*(?:\.[\da-fA-F](?:_?[\da-fA-D])*)?(?:[pP][+-]?\d(?:_?\d)*)?)\b|\binf\b|\bnan(?::0x[\da-fA-F](?:_?[\da-fA-D])*)?\b/,
	'punctuation': /[()]/
};

(function (Prism) {

	var id = /(?:\B-|\b_|\b)[A-Za-z][\w-]*(?![\w-])/.source;
	var type =
		'(?:' +
		/\b(?:unsigned\s+)?long\s+long(?![\w-])/.source +
		'|' +
		/\b(?:unrestricted|unsigned)\s+[a-z]+(?![\w-])/.source +
		'|' +
		/(?!(?:unrestricted|unsigned)\b)/.source + id + /(?:\s*<(?:[^<>]|<[^<>]*>)*>)?/.source +
		')' + /(?:\s*\?)?/.source;

	var typeInside = {};

	Prism.languages['web-idl'] = {
		'comment': {
			pattern: /\/\/.*|\/\*[\s\S]*?\*\//,
			greedy: true
		},
		'string': {
			pattern: /"[^"]*"/,
			greedy: true
		},

		'namespace': {
			pattern: RegExp(/(\bnamespace\s+)/.source + id),
			lookbehind: true,
		},
		'class-name': [
			{
				pattern: /(^|[^\w-])(?:iterable|maplike|setlike)\s*<(?:[^<>]|<[^<>]*>)*>/,
				lookbehind: true,
				inside: typeInside
			},
			{
				pattern: RegExp(/(\b(?:attribute|const|deleter|getter|optional|setter)\s+)/.source + type),
				lookbehind: true,
				inside: typeInside
			},
			{
				// callback return type
				pattern: RegExp('(' + /\bcallback\s+/.source + id + /\s*=\s*/.source + ')' + type),
				lookbehind: true,
				inside: typeInside
			},
			{
				// typedef
				pattern: RegExp(/(\btypedef\b\s*)/.source + type),
				lookbehind: true,
				inside: typeInside
			},

			{
				pattern: RegExp(/(\b(?:callback|dictionary|enum|interface(?:\s+mixin)?)\s+)(?!(?:interface|mixin)\b)/.source + id),
				lookbehind: true,
			},
			{
				// inheritance
				pattern: RegExp(/(:\s*)/.source + id),
				lookbehind: true,
			},

			// includes and implements
			RegExp(id + /(?=\s+(?:implements|includes)\b)/.source),
			{
				pattern: RegExp(/(\b(?:implements|includes)\s+)/.source + id),
				lookbehind: true,
			},

			{
				// function return type, parameter types, and dictionary members
				pattern: RegExp(type + '(?=' + /\s*(?:\.{3}\s*)?/.source + id + /\s*[(),;=]/.source + ')'),
				inside: typeInside
			},
		],

		'builtin': /\b(?:ArrayBuffer|BigInt64Array|BigUint64Array|ByteString|DOMString|DataView|Float32Array|Float64Array|FrozenArray|Int16Array|Int32Array|Int8Array|ObservableArray|Promise|USVString|Uint16Array|Uint32Array|Uint8Array|Uint8ClampedArray)\b/,
		'keyword': [
			/\b(?:async|attribute|callback|const|constructor|deleter|dictionary|enum|getter|implements|includes|inherit|interface|mixin|namespace|null|optional|or|partial|readonly|required|setter|static|stringifier|typedef|unrestricted)\b/,
			// type keywords
			/\b(?:any|bigint|boolean|byte|double|float|iterable|long|maplike|object|octet|record|sequence|setlike|short|symbol|undefined|unsigned|void)\b/
		],
		'boolean': /\b(?:false|true)\b/,

		'number': {
			pattern: /(^|[^\w-])-?(?:0x[0-9a-f]+|(?:\d+(?:\.\d*)?|\.\d+)(?:e[+-]?\d+)?|NaN|Infinity)(?![\w-])/i,
			lookbehind: true
		},
		'operator': /\.{3}|[=:?<>-]/,
		'punctuation': /[(){}[\].,;]/
	};

	for (var key in Prism.languages['web-idl']) {
		if (key !== 'class-name') {
			typeInside[key] = Prism.languages['web-idl'][key];
		}
	}

	Prism.languages['webidl'] = Prism.languages['web-idl'];

}(Prism));

Prism.languages.wolfram = {
	'comment': // Allow one level of nesting - note: regex taken from applescipt
		/\(\*(?:\(\*(?:[^*]|\*(?!\)))*\*\)|(?!\(\*)[\s\S])*?\*\)/,
	'string': {
		pattern: /"(?:\\.|[^"\\\r\n])*"/,
		greedy: true
	},
	'keyword': /\b(?:Abs|AbsArg|Accuracy|Block|Do|For|Function|If|Manipulate|Module|Nest|NestList|None|Return|Switch|Table|Which|While)\b/,
	'context': {
		pattern: /\b\w+`+\w*/,
		alias: 'class-name'
	},
	'blank': {
		pattern: /\b\w+_\b/,
		alias: 'regex'
	},
	'global-variable': {
		pattern: /\$\w+/,
		alias: 'variable'
	},
	'boolean': /\b(?:False|True)\b/,
	'number': /(?:\b(?=\d)|\B(?=\.))(?:0[bo])?(?:(?:\d|0x[\da-f])[\da-f]*(?:\.\d*)?|\.\d+)(?:e[+-]?\d+)?j?\b/i,
	'operator': /\/\.|;|=\.|\^=|\^:=|:=|<<|>>|<\||\|>|:>|\|->|->|<-|@@@|@@|@|\/@|=!=|===|==|=|\+|-|\[\/-+%=\]=?|!=|\*\*?=?|\/\/?=?|<[<=>]?|>[=>]?|[&|^~]/,
	'punctuation': /[{}[\];(),.:]/
};

Prism.languages.mathematica = Prism.languages.wolfram;
Prism.languages.wl = Prism.languages.wolfram;
Prism.languages.nb = Prism.languages.wolfram;

(function (Prism) {

	/**
	 * If the given language is present, it will insert the given doc comment grammar token into it.
	 *
	 * @param {string} lang
	 * @param {any} docComment
	 */
	function insertDocComment(lang, docComment) {
		if (Prism.languages[lang]) {
			Prism.languages.insertBefore(lang, 'comment', {
				'doc-comment': docComment
			});
		}
	}

	var tag = Prism.languages.markup.tag;

	var slashDocComment = {
		pattern: /\/\/\/.*/,
		greedy: true,
		alias: 'comment',
		inside: {
			'tag': tag
		}
	};
	var tickDocComment = {
		pattern: /'''.*/,
		greedy: true,
		alias: 'comment',
		inside: {
			'tag': tag
		}
	};

	insertDocComment('csharp', slashDocComment);
	insertDocComment('fsharp', slashDocComment);
	insertDocComment('vbnet', tickDocComment);

}(Prism));

(function (Prism) {

	Prism.languages.xquery = Prism.languages.extend('markup', {
		'xquery-comment': {
			pattern: /\(:[\s\S]*?:\)/,
			greedy: true,
			alias: 'comment'
		},
		'string': {
			pattern: /(["'])(?:\1\1|(?!\1)[\s\S])*\1/,
			greedy: true
		},
		'extension': {
			pattern: /\(#.+?#\)/,
			alias: 'symbol'
		},
		'variable': /\$[-\w:]+/,
		'axis': {
			pattern: /(^|[^-])(?:ancestor(?:-or-self)?|attribute|child|descendant(?:-or-self)?|following(?:-sibling)?|parent|preceding(?:-sibling)?|self)(?=::)/,
			lookbehind: true,
			alias: 'operator'
		},
		'keyword-operator': {
			pattern: /(^|[^:-])\b(?:and|castable as|div|eq|except|ge|gt|idiv|instance of|intersect|is|le|lt|mod|ne|or|union)\b(?=$|[^:-])/,
			lookbehind: true,
			alias: 'operator'
		},
		'keyword': {
			pattern: /(^|[^:-])\b(?:as|ascending|at|base-uri|boundary-space|case|cast as|collation|construction|copy-namespaces|declare|default|descending|else|empty (?:greatest|least)|encoding|every|external|for|function|if|import|in|inherit|lax|let|map|module|namespace|no-inherit|no-preserve|option|order(?: by|ed|ing)?|preserve|return|satisfies|schema|some|stable|strict|strip|then|to|treat as|typeswitch|unordered|validate|variable|version|where|xquery)\b(?=$|[^:-])/,
			lookbehind: true
		},
		'function': /[\w-]+(?::[\w-]+)*(?=\s*\()/,
		'xquery-element': {
			pattern: /(element\s+)[\w-]+(?::[\w-]+)*/,
			lookbehind: true,
			alias: 'tag'
		},
		'xquery-attribute': {
			pattern: /(attribute\s+)[\w-]+(?::[\w-]+)*/,
			lookbehind: true,
			alias: 'attr-name'
		},
		'builtin': {
			pattern: /(^|[^:-])\b(?:attribute|comment|document|element|processing-instruction|text|xs:(?:ENTITIES|ENTITY|ID|IDREFS?|NCName|NMTOKENS?|NOTATION|Name|QName|anyAtomicType|anyType|anyURI|base64Binary|boolean|byte|date|dateTime|dayTimeDuration|decimal|double|duration|float|gDay|gMonth|gMonthDay|gYear|gYearMonth|hexBinary|int|integer|language|long|negativeInteger|nonNegativeInteger|nonPositiveInteger|normalizedString|positiveInteger|short|string|time|token|unsigned(?:Byte|Int|Long|Short)|untyped(?:Atomic)?|yearMonthDuration))\b(?=$|[^:-])/,
			lookbehind: true
		},
		'number': /\b\d+(?:\.\d+)?(?:E[+-]?\d+)?/,
		'operator': [
			/[+*=?|@]|\.\.?|:=|!=|<[=<]?|>[=>]?/,
			{
				pattern: /(\s)-(?=\s)/,
				lookbehind: true
			}
		],
		'punctuation': /[[\](){},;:/]/
	});

	Prism.languages.xquery.tag.pattern = /<\/?(?!\d)[^\s>\/=$<%]+(?:\s+[^\s>\/=]+(?:=(?:("|')(?:\\[\s\S]|\{(?!\{)(?:\{(?:\{[^{}]*\}|[^{}])*\}|[^{}])+\}|(?!\1)[^\\])*\1|[^\s'">=]+))?)*\s*\/?>/;
	Prism.languages.xquery['tag'].inside['attr-value'].pattern = /=(?:("|')(?:\\[\s\S]|\{(?!\{)(?:\{(?:\{[^{}]*\}|[^{}])*\}|[^{}])+\}|(?!\1)[^\\])*\1|[^\s'">=]+)/;
	Prism.languages.xquery['tag'].inside['attr-value'].inside['punctuation'] = /^="|"$/;
	Prism.languages.xquery['tag'].inside['attr-value'].inside['expression'] = {
		// Allow for two levels of nesting
		pattern: /\{(?!\{)(?:\{(?:\{[^{}]*\}|[^{}])*\}|[^{}])+\}/,
		inside: Prism.languages.xquery,
		alias: 'language-xquery'
	};

	// The following will handle plain text inside tags
	var stringifyToken = function (token) {
		if (typeof token === 'string') {
			return token;
		}
		if (typeof token.content === 'string') {
			return token.content;
		}
		return token.content.map(stringifyToken).join('');
	};

	var walkTokens = function (tokens) {
		var openedTags = [];
		for (var i = 0; i < tokens.length; i++) {
			var token = tokens[i];
			var notTagNorBrace = false;

			if (typeof token !== 'string') {
				if (token.type === 'tag' && token.content[0] && token.content[0].type === 'tag') {
					// We found a tag, now find its kind

					if (token.content[0].content[0].content === '</') {
						// Closing tag
						if (openedTags.length > 0 && openedTags[openedTags.length - 1].tagName === stringifyToken(token.content[0].content[1])) {
							// Pop matching opening tag
							openedTags.pop();
						}
					} else {
						if (token.content[token.content.length - 1].content === '/>') {
							// Autoclosed tag, ignore
						} else {
							// Opening tag
							openedTags.push({
								tagName: stringifyToken(token.content[0].content[1]),
								openedBraces: 0
							});
						}
					}
				} else if (
					openedTags.length > 0 && token.type === 'punctuation' && token.content === '{' &&
					// Ignore `{{`
					(!tokens[i + 1] || tokens[i + 1].type !== 'punctuation' || tokens[i + 1].content !== '{') &&
					(!tokens[i - 1] || tokens[i - 1].type !== 'plain-text' || tokens[i - 1].content !== '{')
				) {
					// Here we might have entered an XQuery expression inside a tag
					openedTags[openedTags.length - 1].openedBraces++;

				} else if (openedTags.length > 0 && openedTags[openedTags.length - 1].openedBraces > 0 && token.type === 'punctuation' && token.content === '}') {

					// Here we might have left an XQuery expression inside a tag
					openedTags[openedTags.length - 1].openedBraces--;

				} else if (token.type !== 'comment') {
					notTagNorBrace = true;
				}
			}
			if (notTagNorBrace || typeof token === 'string') {
				if (openedTags.length > 0 && openedTags[openedTags.length - 1].openedBraces === 0) {
					// Here we are inside a tag, and not inside an XQuery expression.
					// That's plain text: drop any tokens matched.
					var plainText = stringifyToken(token);

					// And merge text with adjacent text
					if (i < tokens.length - 1 && (typeof tokens[i + 1] === 'string' || tokens[i + 1].type === 'plain-text')) {
						plainText += stringifyToken(tokens[i + 1]);
						tokens.splice(i + 1, 1);
					}
					if (i > 0 && (typeof tokens[i - 1] === 'string' || tokens[i - 1].type === 'plain-text')) {
						plainText = stringifyToken(tokens[i - 1]) + plainText;
						tokens.splice(i - 1, 1);
						i--;
					}

					if (/^\s+$/.test(plainText)) {
						tokens[i] = plainText;
					} else {
						tokens[i] = new Prism.Token('plain-text', plainText, null, plainText);
					}
				}
			}

			if (token.content && typeof token.content !== 'string') {
				walkTokens(token.content);
			}
		}
	};

	Prism.hooks.add('after-tokenize', function (env) {
		if (env.language !== 'xquery') {
			return;
		}
		walkTokens(env.tokens);
	});

}(Prism));

(function (Prism) {

	// https://yaml.org/spec/1.2/spec.html#c-ns-anchor-property
	// https://yaml.org/spec/1.2/spec.html#c-ns-alias-node
	var anchorOrAlias = /[*&][^\s[\]{},]+/;
	// https://yaml.org/spec/1.2/spec.html#c-ns-tag-property
	var tag = /!(?:<[\w\-%#;/?:@&=+$,.!~*'()[\]]+>|(?:[a-zA-Z\d-]*!)?[\w\-%#;/?:@&=+$.~*'()]+)?/;
	// https://yaml.org/spec/1.2/spec.html#c-ns-properties(n,c)
	var properties = '(?:' + tag.source + '(?:[ \t]+' + anchorOrAlias.source + ')?|'
		+ anchorOrAlias.source + '(?:[ \t]+' + tag.source + ')?)';
	// https://yaml.org/spec/1.2/spec.html#ns-plain(n,c)
	// This is a simplified version that doesn't support "#" and multiline keys
	// All these long scarry character classes are simplified versions of YAML's characters
	var plainKey = /(?:[^\s\x00-\x08\x0e-\x1f!"#%&'*,\-:>?@[\]`{|}\x7f-\x84\x86-\x9f\ud800-\udfff\ufffe\uffff]|[?:-]<PLAIN>)(?:[ \t]*(?:(?![#:])<PLAIN>|:<PLAIN>))*/.source
		.replace(/<PLAIN>/g, function () { return /[^\s\x00-\x08\x0e-\x1f,[\]{}\x7f-\x84\x86-\x9f\ud800-\udfff\ufffe\uffff]/.source; });
	var string = /"(?:[^"\\\r\n]|\\.)*"|'(?:[^'\\\r\n]|\\.)*'/.source;

	/**
	 *
	 * @param {string} value
	 * @param {string} [flags]
	 * @returns {RegExp}
	 */
	function createValuePattern(value, flags) {
		flags = (flags || '').replace(/m/g, '') + 'm'; // add m flag
		var pattern = /([:\-,[{]\s*(?:\s<<prop>>[ \t]+)?)(?:<<value>>)(?=[ \t]*(?:$|,|\]|\}|(?:[\r\n]\s*)?#))/.source
			.replace(/<<prop>>/g, function () { return properties; }).replace(/<<value>>/g, function () { return value; });
		return RegExp(pattern, flags);
	}

	Prism.languages.yaml = {
		'scalar': {
			pattern: RegExp(/([\-:]\s*(?:\s<<prop>>[ \t]+)?[|>])[ \t]*(?:((?:\r?\n|\r)[ \t]+)\S[^\r\n]*(?:\2[^\r\n]+)*)/.source
				.replace(/<<prop>>/g, function () { return properties; })),
			lookbehind: true,
			alias: 'string'
		},
		'comment': /#.*/,
		'key': {
			pattern: RegExp(/((?:^|[:\-,[{\r\n?])[ \t]*(?:<<prop>>[ \t]+)?)<<key>>(?=\s*:\s)/.source
				.replace(/<<prop>>/g, function () { return properties; })
				.replace(/<<key>>/g, function () { return '(?:' + plainKey + '|' + string + ')'; })),
			lookbehind: true,
			greedy: true,
			alias: 'atrule'
		},
		'directive': {
			pattern: /(^[ \t]*)%.+/m,
			lookbehind: true,
			alias: 'important'
		},
		'datetime': {
			pattern: createValuePattern(/\d{4}-\d\d?-\d\d?(?:[tT]|[ \t]+)\d\d?:\d{2}:\d{2}(?:\.\d*)?(?:[ \t]*(?:Z|[-+]\d\d?(?::\d{2})?))?|\d{4}-\d{2}-\d{2}|\d\d?:\d{2}(?::\d{2}(?:\.\d*)?)?/.source),
			lookbehind: true,
			alias: 'number'
		},
		'boolean': {
			pattern: createValuePattern(/false|true/.source, 'i'),
			lookbehind: true,
			alias: 'important'
		},
		'null': {
			pattern: createValuePattern(/null|~/.source, 'i'),
			lookbehind: true,
			alias: 'important'
		},
		'string': {
			pattern: createValuePattern(string),
			lookbehind: true,
			greedy: true
		},
		'number': {
			pattern: createValuePattern(/[+-]?(?:0x[\da-f]+|0o[0-7]+|(?:\d+(?:\.\d*)?|\.\d+)(?:e[+-]?\d+)?|\.inf|\.nan)/.source, 'i'),
			lookbehind: true
		},
		'tag': tag,
		'important': anchorOrAlias,
		'punctuation': /---|[:[\]{}\-,|>?]|\.\.\./
	};

	Prism.languages.yml = Prism.languages.yaml;

}(Prism));

(function () {

	if (typeof Prism === 'undefined' || typeof document === 'undefined') {
		return;
	}

	// Copied from the markup language definition
	var HTML_TAG = /<\/?(?!\d)[^\s>\/=$<%]+(?:\s(?:\s*[^\s>\/=]+(?:\s*=\s*(?:"[^"]*"|'[^']*'|[^\s'">=]+(?=[\s>]))|(?=[\s/>])))+)?\s*\/?>/g;

	// a regex to validate hexadecimal colors
	var HEX_COLOR = /^#?((?:[\da-f]){3,4}|(?:[\da-f]{2}){3,4})$/i;

	/**
	 * Parses the given hexadecimal representation and returns the parsed RGBA color.
	 *
	 * If the format of the given string is invalid, `undefined` will be returned.
	 * Valid formats are: `RGB`, `RGBA`, `RRGGBB`, and `RRGGBBAA`.
	 *
	 * Hexadecimal colors are parsed because they are not fully supported by older browsers, so converting them to
	 * `rgba` functions improves browser compatibility.
	 *
	 * @param {string} hex
	 * @returns {string | undefined}
	 */
	function parseHexColor(hex) {
		var match = HEX_COLOR.exec(hex);
		if (!match) {
			return undefined;
		}
		hex = match[1]; // removes the leading "#"

		// the width and number of channels
		var channelWidth = hex.length >= 6 ? 2 : 1;
		var channelCount = hex.length / channelWidth;

		// the scale used to normalize 4bit and 8bit values
		var scale = channelWidth == 1 ? 1 / 15 : 1 / 255;

		// normalized RGBA channels
		var channels = [];
		for (var i = 0; i < channelCount; i++) {
			var int = parseInt(hex.substr(i * channelWidth, channelWidth), 16);
			channels.push(int * scale);
		}
		if (channelCount == 3) {
			channels.push(1); // add alpha of 100%
		}

		// output
		var rgb = channels.slice(0, 3).map(function (x) {
			return String(Math.round(x * 255));
		}).join(',');
		var alpha = String(Number(channels[3].toFixed(3))); // easy way to round 3 decimal places

		return 'rgba(' + rgb + ',' + alpha + ')';
	}

	/**
	 * Validates the given Color using the current browser's internal implementation.
	 *
	 * @param {string} color
	 * @returns {string | undefined}
	 */
	function validateColor(color) {
		var s = new Option().style;
		s.color = color;
		return s.color ? color : undefined;
	}

	/**
	 * An array of function which parse a given string representation of a color.
	 *
	 * These parser serve as validators and as a layer of compatibility to support color formats which the browser
	 * might not support natively.
	 *
	 * @type {((value: string) => (string|undefined))[]}
	 */
	var parsers = [
		parseHexColor,
		validateColor
	];


	Prism.hooks.add('wrap', function (env) {
		if (env.type === 'color' || env.classes.indexOf('color') >= 0) {
			var content = env.content;

			// remove all HTML tags inside
			var rawText = content.split(HTML_TAG).join('');

			var color;
			for (var i = 0, l = parsers.length; i < l && !color; i++) {
				color = parsers[i](rawText);
			}

			if (!color) {
				return;
			}

			var previewElement = '<span class="inline-color-wrapper"><span class="inline-color" style="background-color:' + color + ';"></span></span>';
			env.content = previewElement + content;
		}
	});

}());

(function () {

	if (typeof Prism === 'undefined' || typeof document === 'undefined') {
		return;
	}

	var callbacks = [];
	var map = {};
	var noop = function () {};

	Prism.plugins.toolbar = {};

	/**
	 * @typedef ButtonOptions
	 * @property {string} text The text displayed.
	 * @property {string} [url] The URL of the link which will be created.
	 * @property {Function} [onClick] The event listener for the `click` event of the created button.
	 * @property {string} [className] The class attribute to include with element.
	 */

	/**
	 * Register a button callback with the toolbar.
	 *
	 * @param {string} key
	 * @param {ButtonOptions|Function} opts
	 */
	var registerButton = Prism.plugins.toolbar.registerButton = function (key, opts) {
		var callback;

		if (typeof opts === 'function') {
			callback = opts;
		} else {
			callback = function (env) {
				var element;

				if (typeof opts.onClick === 'function') {
					element = document.createElement('button');
					element.type = 'button';
					element.addEventListener('click', function () {
						opts.onClick.call(this, env);
					});
				} else if (typeof opts.url === 'string') {
					element = document.createElement('a');
					element.href = opts.url;
				} else {
					element = document.createElement('span');
				}

				if (opts.className) {
					element.classList.add(opts.className);
				}

				element.textContent = opts.text;

				return element;
			};
		}

		if (key in map) {
			console.warn('There is a button with the key "' + key + '" registered already.');
			return;
		}

		callbacks.push(map[key] = callback);
	};

	/**
	 * Returns the callback order of the given element.
	 *
	 * @param {HTMLElement} element
	 * @returns {string[] | undefined}
	 */
	function getOrder(element) {
		while (element) {
			var order = element.getAttribute('data-toolbar-order');
			if (order != null) {
				order = order.trim();
				if (order.length) {
					return order.split(/\s*,\s*/g);
				} else {
					return [];
				}
			}
			element = element.parentElement;
		}
	}

	/**
	 * Post-highlight Prism hook callback.
	 *
	 * @param env
	 */
	var hook = Prism.plugins.toolbar.hook = function (env) {
		// Check if inline or actual code block (credit to line-numbers plugin)
		var pre = env.element.parentNode;
		if (!pre || !/pre/i.test(pre.nodeName)) {
			return;
		}

		// Autoloader rehighlights, so only do this once.
		if (pre.parentNode.classList.contains('code-toolbar')) {
			return;
		}

		// Create wrapper for <pre> to prevent scrolling toolbar with content
		var wrapper = document.createElement('div');
		wrapper.classList.add('code-toolbar');
		pre.parentNode.insertBefore(wrapper, pre);
		wrapper.appendChild(pre);

		// Setup the toolbar
		var toolbar = document.createElement('div');
		toolbar.classList.add('toolbar');

		// order callbacks
		var elementCallbacks = callbacks;
		var order = getOrder(env.element);
		if (order) {
			elementCallbacks = order.map(function (key) {
				return map[key] || noop;
			});
		}

		elementCallbacks.forEach(function (callback) {
			var element = callback(env);

			if (!element) {
				return;
			}

			var item = document.createElement('div');
			item.classList.add('toolbar-item');

			item.appendChild(element);
			toolbar.appendChild(item);
		});

		// Add our toolbar to the currently created wrapper of <pre> tag
		wrapper.appendChild(toolbar);
	};

	registerButton('label', function (env) {
		var pre = env.element.parentNode;
		if (!pre || !/pre/i.test(pre.nodeName)) {
			return;
		}

		if (!pre.hasAttribute('data-label')) {
			return;
		}

		var element; var template;
		var text = pre.getAttribute('data-label');
		try {
			// Any normal text will blow up this selector.
			template = document.querySelector('template#' + text);
		} catch (e) { /* noop */ }

		if (template) {
			element = template.content;
		} else {
			if (pre.hasAttribute('data-url')) {
				element = document.createElement('a');
				element.href = pre.getAttribute('data-url');
			} else {
				element = document.createElement('span');
			}

			element.textContent = text;
		}

		return element;
	});

	/**
	 * Register the toolbar with Prism.
	 */
	Prism.hooks.add('complete', hook);
}());

(function () {

	if (typeof Prism === 'undefined' || typeof document === 'undefined') {
		return;
	}

	if (!Prism.plugins.toolbar) {
		console.warn('Copy to Clipboard plugin loaded before Toolbar plugin.');

		return;
	}

	/**
	 * When the given elements is clicked by the user, the given text will be copied to clipboard.
	 *
	 * @param {HTMLElement} element
	 * @param {CopyInfo} copyInfo
	 *
	 * @typedef CopyInfo
	 * @property {() => string} getText
	 * @property {() => void} success
	 * @property {(reason: unknown) => void} error
	 */
	function registerClipboard(element, copyInfo) {
		element.addEventListener('click', function () {
			copyTextToClipboard(copyInfo);
		});
	}

	// https://stackoverflow.com/a/30810322/7595472

	/** @param {CopyInfo} copyInfo */
	function fallbackCopyTextToClipboard(copyInfo) {
		var textArea = document.createElement('textarea');
		textArea.value = copyInfo.getText();

		// Avoid scrolling to bottom
		textArea.style.top = '0';
		textArea.style.left = '0';
		textArea.style.position = 'fixed';

		document.body.appendChild(textArea);
		textArea.focus();
		textArea.select();

		try {
			var successful = document.execCommand('copy');
			setTimeout(function () {
				if (successful) {
					copyInfo.success();
				} else {
					copyInfo.error();
				}
			}, 1);
		} catch (err) {
			setTimeout(function () {
				copyInfo.error(err);
			}, 1);
		}

		document.body.removeChild(textArea);
	}
	/** @param {CopyInfo} copyInfo */
	function copyTextToClipboard(copyInfo) {
		if (navigator.clipboard) {
			navigator.clipboard.writeText(copyInfo.getText()).then(copyInfo.success, function () {
				// try the fallback in case `writeText` didn't work
				fallbackCopyTextToClipboard(copyInfo);
			});
		} else {
			fallbackCopyTextToClipboard(copyInfo);
		}
	}

	/**
	 * Selects the text content of the given element.
	 *
	 * @param {Element} element
	 */
	function selectElementText(element) {
		// https://stackoverflow.com/a/20079910/7595472
		window.getSelection().selectAllChildren(element);
	}

	/**
	 * Traverses up the DOM tree to find data attributes that override the default plugin settings.
	 *
	 * @param {Element} startElement An element to start from.
	 * @returns {Settings} The plugin settings.
	 * @typedef {Record<"copy" | "copy-error" | "copy-success" | "copy-timeout", string | number>} Settings
	 */
	function getSettings(startElement) {
		/** @type {Settings} */
		var settings = {
			'copy': 'Copy',
			'copy-error': 'Press Ctrl+C to copy',
			'copy-success': 'Copied!',
			'copy-timeout': 5000
		};

		var prefix = 'data-prismjs-';
		for (var key in settings) {
			var attr = prefix + key;
			var element = startElement;
			while (element && !element.hasAttribute(attr)) {
				element = element.parentElement;
			}
			if (element) {
				settings[key] = element.getAttribute(attr);
			}
		}
		return settings;
	}

	// Prism.plugins.toolbar.registerButton('copy-to-clipboard', function (env) {
	// 	var element = env.element;

	// 	var settings = getSettings(element);

	// 	var linkCopy = document.createElement('button');
	// 	linkCopy.className = 'copy-to-clipboard-button';
	// 	linkCopy.setAttribute('type', 'button');
	// 	var linkSpan = document.createElement('span');
	// 	linkCopy.appendChild(linkSpan);

	// 	setState('copy');

	// 	registerClipboard(linkCopy, {
	// 		getText: function () {
	// 			return element.textContent;
	// 		},
	// 		success: function () {
	// 			setState('copy-success');

	// 			resetText();
	// 		},
	// 		error: function () {
	// 			setState('copy-error');

	// 			setTimeout(function () {
	// 				selectElementText(element);
	// 			}, 1);

	// 			resetText();
	// 		}
	// 	});

	// 	return linkCopy;

	// 	function resetText() {
	// 		setTimeout(function () { setState('copy'); }, settings['copy-timeout']);
	// 	}

	// 	/** @param {"copy" | "copy-error" | "copy-success"} state */
	// 	function setState(state) {
	// 		linkSpan.textContent = settings[state];
	// 		linkCopy.setAttribute('data-copy-state', state);
	// 	}
	// });

}());

(function () {

	if (typeof Prism === 'undefined' || typeof document === 'undefined' || !document.querySelector) {
		return;
	}

	Prism.plugins.toolbar.registerButton('download-file', function (env) {
		var pre = env.element.parentNode;
		if (!pre || !/pre/i.test(pre.nodeName) || !pre.hasAttribute('data-src') || !pre.hasAttribute('data-download-link')) {
			return;
		}
		var src = pre.getAttribute('data-src');
		var a = document.createElement('a');
		a.textContent = pre.getAttribute('data-download-link-label') || 'Download';
		a.setAttribute('download', '');
		a.href = src;
		return a;
	});

}());

(function () {

	if (typeof Prism === 'undefined') {
		return;
	}


	var LANGUAGE_REGEX = /^diff-([\w-]+)/i;
	var HTML_TAG = /<\/?(?!\d)[^\s>\/=$<%]+(?:\s(?:\s*[^\s>\/=]+(?:\s*=\s*(?:"[^"]*"|'[^']*'|[^\s'">=]+(?=[\s>]))|(?=[\s/>])))+)?\s*\/?>/g;
	//this will match a line plus the line break while ignoring the line breaks HTML tags may contain.
	var HTML_LINE = RegExp(/(?:__|[^\r\n<])*(?:\r\n?|\n|(?:__|[^\r\n<])(?![^\r\n]))/.source.replace(/__/g, function () { return HTML_TAG.source; }), 'gi');

	var warningLogged = false;

	Prism.hooks.add('before-sanity-check', function (env) {
		var lang = env.language;
		if (LANGUAGE_REGEX.test(lang) && !env.grammar) {
			env.grammar = Prism.languages[lang] = Prism.languages.diff;
		}
	});
	Prism.hooks.add('before-tokenize', function (env) {
		if (!warningLogged && !Prism.languages.diff && !Prism.plugins.autoloader) {
			warningLogged = true;
			console.warn("Prism's Diff Highlight plugin requires the Diff language definition (prism-diff.js)." +
				"Make sure the language definition is loaded or use Prism's Autoloader plugin.");
		}

		var lang = env.language;
		if (LANGUAGE_REGEX.test(lang) && !Prism.languages[lang]) {
			Prism.languages[lang] = Prism.languages.diff;
		}
	});

	Prism.hooks.add('wrap', function (env) {
		var diffLanguage; var diffGrammar;

		if (env.language !== 'diff') {
			var langMatch = LANGUAGE_REGEX.exec(env.language);
			if (!langMatch) {
				return; // not a language specific diff
			}

			diffLanguage = langMatch[1];
			diffGrammar = Prism.languages[diffLanguage];
		}

		var PREFIXES = Prism.languages.diff && Prism.languages.diff.PREFIXES;

		// one of the diff tokens without any nested tokens
		if (PREFIXES && env.type in PREFIXES) {
			/** @type {string} */
			var content = env.content.replace(HTML_TAG, ''); // remove all HTML tags

			/** @type {string} */
			var decoded = content.replace(/&lt;/g, '<').replace(/&amp;/g, '&');

			// remove any one-character prefix
			var code = decoded.replace(/(^|[\r\n])./g, '$1');

			// highlight, if possible
			var highlighted;
			if (diffGrammar) {
				highlighted = Prism.highlight(code, diffGrammar, diffLanguage);
			} else {
				highlighted = Prism.util.encode(code);
			}

			// get the HTML source of the prefix token
			var prefixToken = new Prism.Token('prefix', PREFIXES[env.type], [/\w+/.exec(env.type)[0]]);
			var prefix = Prism.Token.stringify(prefixToken, env.language);

			// add prefix
			var lines = []; var m;
			HTML_LINE.lastIndex = 0;
			while ((m = HTML_LINE.exec(highlighted))) {
				lines.push(prefix + m[0]);
			}
			if (/(?:^|[\r\n]).$/.test(decoded)) {
				// because both "+a\n+" and "+a\n" will map to "a\n" after the line prefixes are removed
				lines.push(prefix);
			}
			env.content = lines.join('');

			if (diffGrammar) {
				env.classes.push('language-' + diffLanguage);
			}
		}
	});

}());

