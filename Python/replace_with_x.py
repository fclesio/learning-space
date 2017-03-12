import re

text = "fflavioclesio8417889479374912873s8172930749817349127390132"


def replace_with_X(n):
    
    n = text

    if len(n) >= 9:
        replaced = re.sub("\d", "x", n[9:2147483648])
        print (replaced)
    else:
       print ("Error")
   
   
replace_with_X (text)
   
   



new_string = re.sub("\d", "x", text)

print (new_string)


