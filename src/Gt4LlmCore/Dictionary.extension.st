Extension { #name : #Dictionary }

{ #category : #'*Gt4LlmCore' }
Dictionary >> addContentOneLineSummaryTo: aWriteStream [
	| anIndex |
	anIndex := 0.
	self
		keysAndValuesDo: [ :eachKey :eachValue | 
			anIndex := anIndex + 1.
			eachKey addContentOneLineSummaryTo: aWriteStream.
			aWriteStream nextPutAll: ': '.
			eachValue addContentOneLineSummaryTo: aWriteStream.
			anIndex < self size ifTrue: [ aWriteStream nextPutAll: ', ' ] ]
]
