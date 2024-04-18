Class {
	#name : #GtLlmMessagesGroup,
	#superclass : #GtLlmGroup,
	#category : #'Gt4Llm-Groups'
}

{ #category : #accessing }
GtLlmMessagesGroup >> asJson [
	^ STONJSON toString: self serialize
]

{ #category : #accessing }
GtLlmMessagesGroup >> gtJsonFor: aView [
	<gtView>
	^ aView textEditor
		title: 'JSON';
		priority: 1;
		text: [ self asJson ];
		styler: JSONParser gtStyler
]

{ #category : #accessing }
GtLlmMessagesGroup >> gtMessagesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ self items ];
		column: 'Role'
			text: #role
			width: 100;
		column: 'Message' text: #content
]

{ #category : #accessing }
GtLlmMessagesGroup >> serialize [
	^ {'messages' -> (self items collect: #serialize)} asDictionary
]
