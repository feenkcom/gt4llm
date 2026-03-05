Extension { #name : #String }

{ #category : #'*Gt4LlmCore' }
String >> addContentOneLineSummaryTo: aWriteStream [
	self gtDisplayOn: aWriteStream
]

{ #category : #'*Gt4LlmCore' }
String >> asGtLInstructionPiece [
	^ GtLInstructionString new string: self
]

{ #category : #'*Gt4LlmCore' }
String >> asInstructionPiece [
	^ GtLInstructionString new string: self
]

{ #category : #'*Gt4LlmCore' }
String >> gtLlmStringFor: aView [
	<gtLlmView>
	^ aView textEditor
		title: 'String';
		priority: 1;
		text: [ self ]
]
