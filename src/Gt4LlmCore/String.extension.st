Extension { #name : #String }

{ #category : #'*Gt4LlmCore' }
String >> gtLlmStringFor: aView [
	<gtLlmView>
	^ aView textEditor
		title: 'String';
		priority: 1;
		text: [ self ]
]
