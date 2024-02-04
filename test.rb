unacceptableChars = []
for ascii in 0 .. 128
    if !(ascii >= 48 and ascii <= 57)
        unacceptableChars.push(ascii.chr)
    end
end

for ascii in 0 .. unacceptableChars.length-1
  #print unacceptableChars[ascii] + " "
end

print "9".to_i + "1".to_i
print "\n"


print 17 / 5
