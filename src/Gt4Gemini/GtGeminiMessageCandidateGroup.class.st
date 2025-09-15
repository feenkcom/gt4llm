Class {
	#name : #GtGeminiMessageCandidateGroup,
	#superclass : #GtGeminiGroup,
	#category : #Gt4Gemini
}

{ #category : #accessing }
GtGeminiMessageCandidateGroup class >> leJsonV4Name [

	^ #gtGeminiMessageCandidateGroup
]

{ #category : #'as yet unclassified' }
GtGeminiMessageCandidateGroup >> gtMessagesFor: aView [
	<gtView>
	^ aView list
		title: 'Messages';
		priority: 1;
		items: [ self items ];
		itemText: [ :aMessage | aMessage content contentText ]
]
