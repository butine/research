import zerorpc
import factom_gateway

b = factom_gateway.BitMedi()

class BitMediRPC(object):
    def login(self,ID):
        res = b.login(ID)
        print res
        return res
        
    def query(self,ID,Hash):
        return b.get_record_from_fct(ID,Hash)

    def append(self,userID,cipher):
        return b.post_record_to_fct("10","jackec",userID,cipher)

    def showAddress(self):
        return b.show_address()

s = zerorpc.Server(BitMediRPC())
s.bind("tcp://0.0.0.0:4242")
s.run()
