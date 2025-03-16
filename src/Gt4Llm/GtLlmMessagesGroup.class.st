Class {
	#name : #GtLlmMessagesGroup,
	#superclass : #GtLlmGroup,
	#category : 'Gt4Llm'
}

{ #category : #converting }
GtLlmMessagesGroup >> asGPhlowItemsIterator [
	^ GtRemotePhlowGenericCollectionIterator forCollection: self
]

{ #category : #accessing }
GtLlmMessagesGroup >> asJson [
	^ STONJSON toString: self serialize
]

{ #category : #accessing }
GtLlmMessagesGroup >> gtMessagesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ self items ];
		column: 'Role'
			text: [ :item | item role ]
			width: 100;
		column: 'Message' text: [ :item | item content ]
]

{ #category : #accessing }
GtLlmMessagesGroup >> serialize [
	^ {'messages' -> (self items collect: #serialize)} asDictionary
]
