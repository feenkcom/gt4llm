Extension { #name : #Object }

{ #category : #'*Gt4LlmCore' }
Object >> addContentOneLineSummaryTo: aWriteStream [
	self gtDisplayOn: aWriteStream
]

{ #category : #'*Gt4LlmCore' }
Object >> contentOneLineMultiLabelSummaryWith: aBuilder [
	aBuilder newTextFromStringStream: [ :aWriteStream | 
		self addContentOneLineSummaryTo: aWriteStream ]
]
