Class {
	#name : #GtGeminiMessageCandidateGroup,
	#superclass : #GtGeminiGroup,
	#category : #Gt4Gemini
}

{ #category : #'as yet unclassified' }
GtGeminiMessageCandidateGroup >> gtMessagesFor: aView [
	<gtView>
	^ aView list
		title: 'Messages';
		priority: 1;
		items: [ self items ];
		itemText: [ :aMessage | aMessage content contentText ]
]
