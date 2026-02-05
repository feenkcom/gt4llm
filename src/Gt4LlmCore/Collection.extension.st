Extension { #name : #Collection }

{ #category : #'*Gt4LlmCore' }
Collection >> addContentOneLineSummaryTo: aWriteStream [
	self
		do: [ :eachValue | 
			eachValue addContentOneLineSummaryTo: aWriteStream ]
		separatedBy: [ aWriteStream nextPutAll: ', ' ]
]
