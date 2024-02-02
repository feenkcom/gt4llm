Class {
	#name : #Gt4OpenAIAnnotationsGroup,
	#superclass : #Gt4OpenAIGroup,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIAnnotationsGroup >> gtAnnotationsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Annotations';
		priority: 2;
		items: [ self items ];
		column: 'Text' text: #text;
		column: 'Type' text: #type;
		column: 'File'
			text: [ :anAnnotation | anAnnotation file ifNil: [ '' ] ifNotNil: #filename ]
]
