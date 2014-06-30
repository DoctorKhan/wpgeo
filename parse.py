from xml.etree import cElementTree as ET
import sys
import string
	
def ReadSmall(file):
	myfile = open (file, "r")
	xmlstr = myfile.read()
	myfile.close()
	return xmlstr

def GetRoot(xmlstr):
	xmlstr = filter(lambda x: x in string.printable, xmlstr)
	xmlstr = xmlstr.translate(None, '#$&')
	xmlstr = '<root>' + xmlstr + '</root>'
	root = ET.fromstring(xmlstr)
	return root

def GetLinks(root):
	voLinks = root.findall('.//link')
	L = list()
	for oLink in voLinks:
		if (not(oLink.text is None) and (len(oLink.text) > 0)):
			L.append(oLink.text.split('|')[0])
	return tuple(L)

def GetTitle(root):
	sTitle = root.find('.//title').text
	return tuple([sTitle])
	
def GetCoord(root):

	oCoord = root.find('.//coord')
	if (oCoord is None) or len(oCoord.text) == 0:
		sCoord = ""
	else:
		sCoord = oCoord.text

        return

def ParseCoord(sCoord):
	ns = float(0)
	ew = float(0)
	
        csCoord = sCoord.split('|')
	if csCoord[0] == "missing":
		return (ns,ew)
		
	if len(csCoord) > 7:
		if csCoord[3] == 'N':
			ns = float(csCoord[0]) + float(csCoord[1])/60 + float(csCoord[2])/3600
		if csCoord[3] == 'S':
			ns = -float(csCoord[0]) - float(csCoord[1])/60 - float(csCoord[2])/3600
		if csCoord[7] == 'E':
			ew = float(csCoord[4]) + float(csCoord[5])/60 + float(csCoord[6])/3600
		if csCoord[7] == 'W':
			ew = -float(csCoord[4]) - float(csCoord[5])/60 - float(csCoord[6])/3600

	if len(csCoord) > 5:
		if csCoord[2] == 'N':
			ns = float(csCoord[0]) + float(csCoord[1])/60
		if csCoord[2] == 'S':
			ns = -float(csCoord[0]) - float(csCoord[1])/60
		if csCoord[5] == 'E':
			ew =  float(csCoord[3]) + float(csCoord[4])/60
		if csCoord[5] == 'W':
			ew = -float(csCoord[3]) - float(csCoord[4])/60
		return (ns,ew)

	if len(csCoord) > 3:
		if csCoord[1] == 'N':
			ns = float(csCoord[0])
		if csCoord[1] == 'S':
			ns = -float(csCoord[0])
		if csCoord[3] == 'E':
			ew =  float(csCoord[2])
		if csCoord[3] == 'W':
			ew = -float(csCoord[2])
		return (ns,ew)
		
	if len(csCoord) > 1:
            try:
                ns = float(csCoord[0])
		ew = float(csCoord[1])
		return (ns,ew)
            except ValueError, e:
                return (0.0,0.0)
	return (0.0,0.0)
	
def GetAll(sInput):
	root = GetRoot(sInput)
	"""tAll = GetTitle(root) + GetCoord(root) + GetLinks(root)"""
	tAll = GetCoord(root)
	return tAll

for line in sys.stdin:
	print ParseCoord(line)
