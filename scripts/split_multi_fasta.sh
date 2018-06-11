awk '/>/ {counter+=1; OUT=counter".fa"}; OUT{print >OUT}' 
