Class {
	#name : #GtOpenAIAnnotationsGroup,
	#superclass : #GtOpenAIGroup,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIAnnotationsGroup >> gtAnnotationsFor: aView [
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
