import sys
import re
def ReverseComplement1(seq):
    seq_dict = {'A':'T','T':'A','G':'C','C':'G','N':'N'}
    return "".join([seq_dict[base] for base in reversed(seq)])


def main():
#if __name__ == "__main__":
    for line in sys.stdin:
        #sys.stderr.write("DEBUG: got line: " + line)
        #sys.stdout.write(line)
	if line[0:1]!="@":
		scaffold=line.split("\t")[2]
		read_start=int(line.split("\t")[3])
		read_sequence=line.split("\t")[9]
		read_name=line.split("\t")[0]
		cigar=line.split("\t")[5]
		split_cigar=re.findall('(\d+)([MIDNSHPX=])', cigar)
		flag=int(line.split("\t")[3])


		trimmend_read_sequence,valid_alignment=trimm_sequence(read_sequence, flag, split_cigar)

		trimmend_cigar_string=remove_clipping_from_cigar_to_string(split_cigar)

		cigar_length=0
		for information in re.findall('(\d+)([MIDNSHPX=])', trimmend_cigar_string):
			if information[1]!="H" and information[1]!="D":
				cigar_length+=int(information[0])


		assert(cigar_length==len(trimmend_read_sequence))
		if valid_alignment==1:
			print read_name +"\t"+ scaffold +"\t"+ str(read_start) +"\t"+ trimmend_cigar_string +"\t"+ trimmend_read_sequence

def remove_clipping_from_cigar_to_string(split_cigar):
	cigar_string=""

	for information in split_cigar:
		if information[1]!="S" and information[1]!="H":
			cigar_string+=information[0]+information[1]
	return cigar_string

def trimm_sequence(read_sequence, flag, split_cigar):

		
		#binary_flag="000000000000000"[len("{0:b}".format(flag)):] +"{0:b}".format(flag)
		#if binary_flag[10]=="1":
		#	read_sequence=ReverseComplement1(read_sequence)

		left_trim=0
		rigth_trim=0

		if split_cigar[0][1]=="S":
			left_trim=int(split_cigar[0][0])
		if split_cigar[1][1]=="S":
			left_trim=int(split_cigar[1][0])	

		if split_cigar[len(split_cigar)-1][1]=="S":
			rigth_trim=int(split_cigar[len(split_cigar)-1][0])
		if split_cigar[len(split_cigar)-2][1]=="S":
			rigth_trim=int(split_cigar[len(split_cigar)-2][0])

		trimmed_sequence=read_sequence[left_trim:len(read_sequence)-rigth_trim]

		valid_alignment=1
		if (left_trim + left_trim) >= len(trimmed_sequence):
			valid_alignment=0			

		return trimmed_sequence,valid_alignment	

main()
