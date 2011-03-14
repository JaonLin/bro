# @TEST-EXEC: bro %INPUT > output
# @TEST-EXEC: btest-diff output

@load software

global ts = network_time();
global matched_software: table[string] of Software::Info = {
	["OpenSSH_4.4"] = 
		[$name="OpenSSH", $version=[$major=4,$minor=4,$minor2=0], $ts=ts],
	["OpenSSH_5.2"] = 
		[$name="OpenSSH", $version=[$major=5,$minor=2,$minor2=0], $ts=ts],
	["Apache/2.0.63 (Unix) mod_auth_kerb/5.3 mod_ssl/2.0.63 OpenSSL/0.9.7a mod_fastcgi/2.4.2"] =
		[$name="Apache", $version=[$major=2,$minor=0,$minor2=63,$addl="Unix"], $ts=ts],
	["Apache/1.3.19 (Unix)"] =
		[$name="Apache", $version=[$major=1,$minor=3,$minor2=19,$addl="Unix"], $ts=ts],
	# $addl is not quite right here, but it's close enough.
	["ProFTPD 1.2.5rc1 Server (Debian)"] =
		[$name="ProFTPD", $version=[$major=1,$minor=2,$minor2=5,$addl="rc"], $ts=ts],
	["wu-2.4.2-academ[BETA-18-VR14](1)"] = 
		[$name="wu", $version=[$major=2,$minor=4,$minor2=2,$addl="academ"], $ts=ts],
	["wu-2.6.2(1)"] =
		[$name="wu", $version=[$major=2,$minor=6,$minor2=2,$addl="1"], $ts=ts],
	["Java1.2.2-JDeveloper"] =
		[$name="Java", $version=[$major=1,$minor=2,$minor2=2,$addl="JDeveloper"], $ts=ts],
	["Java/1.6.0_13"] = 
		[$name="Java", $version=[$major=1,$minor=6,$minor2=0,$addl="13"], $ts=ts],
	# Web Browers are going to have to be pre processed before sending here.  
	# They can't be handled generically by the software framework.
	["Firefox/3.6.7"] =
		[$name="Firefox", $version=[$major=3,$minor=6,$minor2=7], $ts=ts],
	["Firefox/4.0b9pre"] = 
		[$name="Firefox", $version=[$major=4,$minor=0,$minor2=0,$addl="b9pre"], $ts=ts],
};

event bro_init()
	{
	for ( sw in matched_software )
		{
		local output = Software::default_parse(sw, 0.0.0.0, Software::UNKNOWN);
		local sw_test = matched_software[sw];
		if ( sw_test$name == output$name &&
		     Software::cmp_versions(sw_test$version,output$version) == 0 )
			print fmt("success on: %s", sw);
		else
			{
			print fmt("failure on: %s", sw);
			print fmt("    name:    %s", output$name);
			print fmt("    version: %s", output$version);
			}
		}
	}