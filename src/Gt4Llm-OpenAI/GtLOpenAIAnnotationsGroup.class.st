Class {
	#name : #GtLOpenAIAnnotationsGroup,
	#superclass : #GtLOpenAIGroup,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIAnnotationsGroup >> gtAnnotationsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Annotations';
		priority: 2;
		items: [ self items ];
		column: 'Text' text: #text;
		column: 'Type' text: #type;
		column: 'File'
			text: [ :anAnnotation | anAnnotation file ifNil: [ '' ] ifNotNil: [ :aFile | aFile filename ] ]
]
