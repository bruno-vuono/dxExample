(function(root, undefined) {
	
	/* --- Setup --- */

	// Create the local library object, to be exported or referenced globally later
	var lib = {};

	// Current version
	lib.version = '0.3.2';

	/* --- Exposed settings --- */

	// The library's settings configuration object. Contains default parameters for
	// number formatting
	lib.settings = {
		number: {
			precision : 0,		// default precision on numbers is 0
			grouping : 3,		// digit grouping (not implemented yet)
			thousand : ",",
			decimal : "."
		}
	};
	
	/* --- Internal Helper Methods --- */

	// Store reference to possibly-available ECMAScript 5 methods for later
	var nativeMap = Array.prototype.map,
		nativeIsArray = Array.isArray,
		toString = Object.prototype.toString;

	/**
	 * Tests whether supplied parameter is a string
	 * from underscore.js
	 */
	function isString(obj) {
		return !!(obj === '' || (obj && obj.charCodeAt && obj.substr));
	}

	/**
	 * Tests whether supplied parameter is a string
	 * from underscore.js, delegates to ECMA5's native Array.isArray
	 */
	function isArray(obj) {
		return nativeIsArray ? nativeIsArray(obj) : toString.call(obj) === '[object Array]';
	}
	
	/**
	 * Tests whether supplied parameter is a true object
	 */
	function isObject(obj) {
		return obj && toString.call(obj) === '[object Object]';
	}
	
	/**
	 * Extends an object with a defaults object, similar to underscore's _.defaults
	 *
	 * Used for abstracting parameter handling from API methods
	 */
	function defaults(object, defs) {
		var key;
		object = object || {};
		defs = defs || {};
		// Iterate over object non-prototype properties:
		for (key in defs) {
			if (defs.hasOwnProperty(key)) {
				// Replace values with defaults only if undefined (allow empty/zero values):
				if (object[key] == null) object[key] = defs[key];
			}
		}
		return object;
	}

	/**
	 * Implementation of `Array.map()` for iteration loops
	 *
	 * Returns a new Array as a result of calling `iterator` on each array value.
	 * Defers to native Array.map if available
	 */
	function map(obj, iterator, context) {
		var results = [], i, j;

		if (!obj) return results;

		// Use native .map method if it exists:
		if (nativeMap && obj.map === nativeMap) return obj.map(iterator, context);

		// Fallback for native .map:
		for (i = 0, j = obj.length; i < j; i++ ) {
			results[i] = iterator.call(context, obj[i], i, obj);
		}
		return results;
	}

	/**
	 * Check and normalise the value of precision (must be positive integer)
	 */
	function checkPrecision(val, base) {
		val = Math.round(Math.abs(val));
		return isNaN(val)? base : val;
	}

	/**
	 * Implementation of toFixed() that treats floats more like decimals
	 *
	 * Fixes binary rounding issues (eg. (0.615).toFixed(2) === "0.61") that present
	 * problems for formatNumCurr- and finance-related software.
	 */
	var toFixed = lib.toFixed = function(value, precision) {
		precision = checkPrecision(precision, lib.settings.number.precision);
		var power = Math.pow(10, precision);

		// Multiply up by precision, round accurately, then divide and use native toFixed():
		return (Math.round(lib.unformat(value) * power) / power).toFixed(precision);
	};
	
	/**
	 * Format a number, with comma-separated thousands and custom precision/decimal places
	 *
	 * Localise by overriding the precision and thousand / decimal separators
	 * 2nd parameter `precision` can be an object matching `settings.number`
	 */
	var formatNumber = lib.formatNumber = function(number, locale) {
		var precision = 2;
		var thousand = localeCurrencyMap(locale)[0];
		var decimal = localeCurrencyMap(locale)[1];
		// Format number to a decimal that accepts by the formatting process
		var numberStr = number.toString();
		numberStr = numberStr.replace(/[^0-9., ]/g,'').replace(/[., ]/g,'.').split(".");
		numberStr = numberStr.slice(0,-1).join('') + "." + numberStr.slice(-1);
		
		//var number = parseFloat(numberStr); // 00000.00
		
		// Resursively format arrays:
		if (isArray(number)) {
			return map(number, function(val) {
				return formatNumber(val, precision, thousand, decimal);
			});
		}

		// Clean up number:
		number = unformat(number);

		// Build options object from second param (if object) or all params, extending defaults:
		var opts = defaults(
				(isObject(precision) ? precision : {
					precision : precision,
					thousand : thousand,
					decimal : decimal
				}),
				lib.settings.number
			),

			// Clean up precision
			usePrecision = checkPrecision(opts.precision),

			// Do some calc:
			negative = number < 0 ? "-" : "",
			base = parseInt(toFixed(Math.abs(number || 0), usePrecision), 10) + "",
			mod = base.length > 3 ? base.length % 3 : 0;

		// Format the number:
		return negative + (mod ? base.substr(0, mod) + opts.thousand : "") + base.substr(mod).replace(/(\d{3})(?=\d)/g, "$1" + opts.thousand) + (usePrecision ? opts.decimal + toFixed(Math.abs(number), usePrecision).split('.')[1] : "");
	};
	
	/**
	 * Takes a string/array of strings, removes all formatting/cruft and returns the raw float value
	 * alias: formatNumCurr.`parse(string)`
	 *
	 * Decimal must be included in the regular expression to match floats (defaults to
	 * formatNumCurr.settings.number.decimal), so if the number uses a non-standard decimal 
	 * separator, provide it as the second argument.
	 *
	 * Also matches bracketed negatives (eg. "$ (1.99)" => -1.99)
	 *
	 * Doesn't throw any errors (`NaN`s become 0) but this may change in future
	 */
	var unformat = lib.unformat = lib.parse = function(value, decimal) {
		// Recursively unformat arrays:
		if (isArray(value)) {
			return map(value, function(val) {
				return unformat(val, decimal);
			});
		}

		// Fails silently (need decent errors):
		value = value || 0;

		// Return the value as-is if it's already a number:
		if (typeof value === "number") return value;

		// Default decimal point comes from settings, but could be set to eg. "," in opts:
		decimal = decimal || lib.settings.number.decimal;

		 // Build regex to strip out everything except digits, decimal point and minus sign:
		var regex = new RegExp("[^0-9-" + decimal + "]", ["g"]),
			unformatted = parseFloat(
				("" + value)
				.replace(/\((.*)\)/, "-$1") // replace bracketed values with negatives
				.replace(regex, '')         // strip out any cruft
				.replace(decimal, '.')      // make sure decimal point is standard
			);

		// This will fail silently which may cause trouble, let's wait and see:
		return !isNaN(unformatted) ? unformatted : 0;
	};
	
	
	/* --- Module Definition --- */

	// Export formatNumCurr for CommonJS. If being loaded as an AMD module, define it as such.
	// Otherwise, just add `formatNumCurr` to the global object
	if (typeof exports !== 'undefined') {
		if (typeof module !== 'undefined' && module.exports) {
			exports = module.exports = lib;
		}
		exports.formatNumCurr = lib;
	} else if (typeof define === 'function' && define.amd) {
		// Return the library as an AMD module:
		define([], function() {
			return lib;
		});
	} else {
		// Use formatNumCurr.noConflict to restore `formatNumCurr` back to its original value.
		// Returns a reference to the library's `formatNumCurr` object;
		// e.g. `var numbers = formatNumCurr.noConflict();`
		lib.noConflict = (function(oldformatNumCurr) {
			return function() {
				// Reset the value of the root's `formatNumCurr` variable:
				root.formatNumCurr = oldformatNumCurr;
				// Delete the noConflict method:
				lib.noConflict = undefined;
				// Return reference to the library to re-assign it:
				return lib;
			};
		})(root.formatNumCurr);

		// Declare `fx` on the root (global/window) object:
		root['formatNumCurr'] = lib;
	}
	
	function localeCurrencyMap(currCode){
		var currencyMap = {
			"ar" : [",","."],
			"ar_AE" : [",","."],
			"ar_BH" : [",","."],
			"ar_EG" : [",","."],
			"ar_JO" : [",","."],
			"ar_KW" : [",","."],
			"ar_LB" : [",","."],
			"ar_QA" : [",","."],
			"ar_SA" : [",","."],
			"az_AZ" : [".",","],
			"be_BY" : [" ",","],
			"bg" : [" ",","],
			"bg_BG" : [" ",","],
			"bn_BD" : [",","."],
			"bs_BA" : [".",","],
			"ca" : [".",","],
			"ca_ES" : [".",","],
			"cs" : [" ",","],
			"cs_CZ" : [" ",","],
			"cy_GB" : [",","."],
			"da" : [".",","],
			"da_DK" : [".",","],
			"de" : [".",","],
			"de_AT" : [".",","],
			"de_CH" : ["'","."],
			"de_DE" : [".",","],
			"de_LU" : [".",","],
			"el" : [".",","],
			"el_GR" : [".",","],
			"en_AU" : [",","."],
			"en_BB" : [",","."],
			"en_BM" : [",","."],
			"en_CA" : [",","."],
			"en_GB" : [",","."],
			"en_GH" : [",","."],
			"en_ID" : [",","."],
			"en_IE" : [",","."],
			"en_IN" : [",","."],
			"en_MY" : [",","."],
			"en_NG" : [",","."],
			"en_NZ" : [",","."],
			"en_PH" : [",","."],
			"en_PK" : [",","."],
			"en_SG" : [",","."],
			"en_US" : [",","."],
			"en_ZA" : [",","."],
			"es" : [".",","],
			"es_AR" : [".",","],
			"es_BO" : [".",","],
			"es_CL" : [".",","],
			"es_CO" : [".",","],
			"es_CR" : [",","."],
			"es_DO" : [",","."],
			"es_EC" : [".",","],
			"es_ES" : [".",","],
			"es_GT" : [",","."],
			"es_HN" : [",","."],
			"es_MX" : [",","."],
			"es_PA" : [",","."],
			"es_PE" : [".",","],
			"es_PR" : [",","."],
			"es_PY" : [".",","],
			"es_SVUS" : [",","."],
			"es_UY" : [".",","],
			"es_VE" : [".",","],
			"et_EE" : [" ",","],
			"eu_ES" : [".",","],
			"fi" : [" ",","],
			"fi_FI" : [" ",","],
			"fr" : [" ",","],
			"fr_BE" : [".",","],
			"fr_CA" : [" ",","],
			"fr_CH" : ["'","."],
			"fr_FR" : [" ",","],
			"fr_LU" : [" ",","],
			"fr_MC" : [" ",","],
			"ga_IE" : [",","."],
			"hi_IN" : [",","."],
			"hr_HR" : [".",","],
			"hu" : [" ",","],
			"hu_HU" : [" ",","],
			"hy_AM" : [",","."],
			"in" : [".",","],
			"in_ID" : [".",","],
			"is_IS" : [".",","],
			"it" : [".",","],
			"it_CH" : ["'","."],
			"it_IT" : [".",","],
			"iw" : [",","."],
			"iw_IL" : [",","."],
			"ja" : [",","."],
			"ja_JP" : [",","."],
			"ka" : [",","."],
			"ka_GE" : [",","."],
			"kk_KZ" : [",","."],
			"km_KH" : [",","."],
			"ko" : [",","."],
			"ko_KR" : [",","."],
			"ky_KG" : [",","."],
			"lb_LU" : [",","."],
			"lt_LT" : [" ",","],
			"lv_LV" : [" ",","],
			"mk_MK" : [".",","],
			"ms_BN" : [".",","],
			"ms_MY" : [",","."],
			"mt_MT" : [",","."],
			"nl" : [".",","],
			"nl_BE" : [".",","],
			"nl_NL" : [".",","],
			"nl_SR" : [".",","],
			"no" : [" ",","],
			"no_NO" : [" ",","],
			"pl" : [" ",","],
			"pl_PL" : [" ",","],
			"pt" : [".",","],
			"pt_AO" : [".",","],
			"pt_BR" : [".",","],
			"pt_PT" : [".",","],
			"rm_CH" : ["'","."],
			"ro" : [".",","],
			"ro_MD" : [".",","],
			"ro_RO" : [".",","],
			"ru" : [" ",","],
			"ru_RU" : [" ",","],
			"sh" : [".",","],
			"sh_BA" : [".",","],
			"sh_CS" : [".",","],
			"sh_ME" : [".",","],
			"sk" : [" ",","],
			"sk_SK" : [" ",","],
			"sl_SI" : [".",","],
			"sq_AL" : [".",","],
			"sr" : [".",","],
			"sr_BA" : [".",","],
			"sr_CS" : [".",","],
			"sv" : [" ",","],
			"sv_SE" : [" ",","],
			"tg_TJ" : [",","."],
			"th" : [",","."],
			"th_TH" : [",","."],
			"tl" : [",","."],
			"tl_PH" : [",","."],
			"tr" : [".",","],
			"tr_TR" : [".",","],
			"uk" : [".",","],
			"uk_UA" : [".",","],
			"ur_PK" : [",","."],
			"vi" : [".",","],
			"vi_VN" : [".",","],
			"zh" : [",","."],
			"zh_CN" : [",","."],
			"zh_CN_PINYIN" : [",","."],
			"zh_CN_STROKE" : [",","."],
			"zh_HK" : [",","."],
			"zh_HK_STROKE" : [",","."],
			"zh_MO" : [",","."],
			"zh_SG" : [",","."],
			"zh_TW" : [",","."],
			"zh_TW_STROKE" : [",","."]
		}
		
		return currencyMap[currCode];
	}
	
	// Root will be `window` in browser or `global` on the server:
}(this));	