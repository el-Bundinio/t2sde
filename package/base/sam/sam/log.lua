-- --- T2-COPYRIGHT-NOTE-BEGIN ---
-- T2 SDE: package/*/sam/sam/log.lua
-- Copyright (C) 2006 - 2022 The T2 SDE Project
-- 
-- This Copyright note is generated by scripts/Create-CopyPatch,
-- more information can be found in the files COPYING and README.
-- 
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License version 2.
-- --- T2-COPYRIGHT-NOTE-END ---

sam = sam or {}

--[[ DESCRIPTION ] ----------------------------------------------------------

Provided functions:

* sam.log(required-verbosity-level, identification, printf-format...)

    Print information about SAM processing. The logging level (sam.opt.loglevel)
    has to be equal or higher than "required-verbosity-level". The
    "identification" is printed in square brackets in front of the message.

    Example:
      sam.log(sam.log.ERROR, "Config", "Config file incosistency (%s)",
	          filename)


* sam.error(identification, format...)
* sam.warn(identification, format...)
* sam.notice(identification, format...)
* sam.info(identification, format...)
* sam.dbg(identification, format...)

    Short form for the logging function.

--]] ------------------------------------------------------------------------

sam.log = {
	ERROR  = 0,
	WARN   = 1,
	NOTICE = 2,
	INFO   = 3,
	DEBUG  = 4,
}

sam.error  = function(ident,...) sam.log(sam.log.ERROR, ident, unpack(arg)) end
sam.warn   = function(ident,...) sam.log(sam.log.WARN, ident, unpack(arg)) end
sam.notice = function(ident,...) sam.log(sam.log.NOTICE, ident, unpack(arg)) end
sam.info   = function(ident,...) sam.log(sam.log.INFO, ident, unpack(arg)) end
sam.dbg    = function(ident,...) sam.log(sam.log.DEBUG, ident, unpack(arg)) end

-- log_stdout(required-log-level, identification, fmt...)
--   The default logging method is to log to stderr.
local function log_stdout(reqlvl, ident, ...)
	if sam.opt.loglevel >= reqlvl then
		io.stderr:write(string.format("[%s] ", ident))
		io.stderr:write(string.format(unpack(arg)))
	end
end

-- sam.log(required-log-level, identification, fmt...)
--   sam.log can be called as function via a metatable,
--   default: log_stdout
setmetatable(sam.log, {
	__call = function(self, reqlvl, ident,  ...) 
			log_stdout(reqlvl, ident, unpack(arg))
		 end
})
