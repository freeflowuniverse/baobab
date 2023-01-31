module rmbprocessor

import freeflowuniverse.crystallib.keysafe

// the metadata as we need to remember for all other clients
pub struct TwinMetaPub {
pub:
	signingkey    []u8     // signing key as used whens signing the payload (public part, just to verify)
	publickey     []u8     // nacl publickey	
	twinid        u32      // who am i
	rmb_proxy_ips []string // how do we find our way back, if empty list, then is local, are ip addresses
	ipaddr        string   // if relevant what is our IP address
	signature     string   // signature of encoded list of: signignkey, publickey, twinid, rmb_proxy_ips, ipaddr
}

// is the struct as we use it in our V process
pub struct MyTwin {
pub:
	twinid        u32      // who am i
	rmb_proxy_ips []string // how do we find our way back, if empty list, then is local, are ip addresses
	ipaddr        string
	privkey       keysafe.PrivKey // is link to all required info to do encryption, signing, ...
}
