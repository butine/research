#!/usr/bin/env python
# this is a main communication interface for factom block chain
# HAO CHEN

# --------- imports ---------
import os
import csv
import sys
import json
import requests
import sqlite3

# --------- classes ---------

class BitMedi:
    def __init__(self):
        self.url = "http://localhost:8089/v1/"
        self.url2 = "http://localhost:8088/v1/"
        self.bitmedi_chain_dic = {}
        self.bitmedi_entry_dic = {}
	# init a chain for post and inquiry
    	# 10 = local chain id ; jackec = Entry Credit Addresses name
	# you can and more chain with local chain id and ec name
	self.init_chain("10", "jackec")
	self.db_con = sqlite3.connect('cached.db')

    def fct_post(self, method, action, target, values):
        """
	private base api
        this function for posting data from bitmedi svr from factom svr.
        url - factom svr url
        action - factom action, compose-chain-submit etc.
        target - factom element, address, chain (name) etc.
        url + action + target gives the whole URL to aceess fcactom svr
        data - the data need to submit.
        """

        jdata = json.dumps(values)
        if method == "fctwallet":
            s = requests.post(self.url+action+"/"+target, jdata)
            return s.json()
        else:
            #response 200
            return requests.post(self.url2+action+"/"+target, jdata)

    def fct_inquiry(self, method, action, target):
        """
	private base api
        this function for inquiry data from bitmedi svr from factom svr.
        url - factom svr url
        action - factom action, compose-chain-submit etc.
        target - factom element, address, chain (name) etc.
        url + action + target gives the whole URL to aceess fcactom svr
        """

        if method == "fctwallet":
            return requests.get(self.url+action+"/"+target).json()
        else:
            return requests.get(self.url2+action+"/"+target)

    def local_validate(self):
        pass

    def init_chain(self, seq, entry_name):
	"""
	generate a new chain with humman-read seq for token chain
	"""
        values = {"ExtIDs":["bitmedi", seq], 
                    "Content":"NO."+seq+" chain of bitmedi"}
        s = self.fct_post("fctwallet", "compose-chain-submit", entry_name, values)
        self.bitmedi_chain_dic.setdefault(seq, s[u'ChainID'])
        self.fct_post("factomd", "commit-chain", "", s[u'ChainCommit'])
        self.fct_post("factomd", "reveal-chain", "", s[u'EntryReveal'])

    def post_record_to_fct(self, seq, entry_name, user_id, enc_content):
	"""
	post record to factom with user_id, enc_content
	"""
        values = {"ChainID":self.bitmedi_chain_dic[seq], 
                    "ExtIDs":[user_id], 
                    "Content":enc_content}
        s = self.fct_post("fctwallet", "compose-entry-submit", entry_name, values)
        entry_hashed=s[u'EntryCommit'][u'CommitEntryMsg'][14:78]

	# if user exist in list
	#if self.bitmedi_entry_dic.has_key(user_id):
	#	self.bitmedi_entry_dic[user_id].append(entry_hashed)
	#else:
        #	self.bitmedi_entry_dic.setdefault(user_id, [entry_hashed,])

        # save user_id, entry_hash here(light database)
	self.db_con.execute("INSERT INTO CACHED VALUES ('"+user_id+"', '"+entry_hashed+"');")
	self.db_con.commit()

        self.fct_post("factomd", "commit-entry", "", s[u'EntryCommit'])
        self.fct_post("factomd", "reveal-entry", "", s[u'EntryReveal'])
	return entry_hashed

    def get_record_from_fct(self, user_id, entry_hashed):
	"""
	get record from factom with entry_hashed
	return content
	"""
        s = self.fct_inquiry("factomd", "entry-by-hash", entry_hashed)
        jdata = s.json()
        #print jdata
        # now convert HEX to string to print
        #print jdata[u'Content'].decode('hex')
        return jdata[u'Content'].decode('hex')

    def login(self, user_id):
	"""
	a user login in with his/her/its user_id
	return his/her/its entry_hashed list
	"""
	cur = self.db_con.execute("select entryhashed from cached where userid='"+user_id+"';")
    	cur_list = []
    	for row in cur:
		cur_list.append(row)
	return cur_list

    def show_balance(self, entry_addr):
        return self.fct_inquiry("fctwallet", "factoid-balance", entry_addr)

    def show_address(self):
        return self.fct_inquiry("fctwallet", "factoid-get-addresses", "")


# --------- main ---------
if __name__ == '__main__':
    print "testing begin"

    b=BitMedi()
    print b.bitmedi_chain_dic
    # chenhao = user id ; code = content for encryption info
    #b.post_record_to_fct("10", "jackec", "chenhao", "code")
    #b.post_record_to_fct("10", "jackec", "chenhao", "code2")
    #b.post_record_to_fct("10", "jackec", "chenhao", "code3")
    #user_cur = b.db_con.execute("select userid,entryhashed from cached;")
    #user_list = []
    #for row in user_cur:
    #    user_list.append(row)
    #print user_list
    print b.login("chenhao")
	
    #print b.bitmedi_entry_dic
    #b.get_record_from_fct("chenhao", b.bitmedi_entry_dic["chenhao"][0])
    #b.get_record_from_fct("chenhao", b.bitmedi_entry_dic["chenhao"][1])

    #b.show_balance()
    #b.show_address()

