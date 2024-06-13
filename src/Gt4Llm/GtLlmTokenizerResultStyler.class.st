Class {
	#name : #GtLlmTokenizerResultStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'result'
	],
	#category : #'Gt4Llm-Tokenizer'
}

{ #category : #accessing }
GtLlmTokenizerResultStyler >> privateStyle: aText [
	<return: #BlText>
	| color |
	color := BrGlamorousColors newsBackgroundColor.

	self result tokens
		do: [ :aToken | 
			(aText from: aToken start to: aToken end)
				attribute: (BrTextHoverAttribute new
						enterAction: [ self result tokens
								do: [ :anotherToken | 
									aToken num = anotherToken num
										ifTrue: [ (aText from: anotherToken start to: anotherToken end) highlight: color ] ] ];
						leaveAction: [ self result tokens
								do: [ :anotherToken | 
									aToken num = anotherToken num
										ifTrue: [ (aText from: anotherToken start to: anotherToken end)
												highlight: Color transparent ] ] ]) ].
	^ aText
]

{ #category : #accessing }
GtLlmTokenizerResultStyler >> result [
	^ result
]

{ #category : #accessing }
GtLlmTokenizerResultStyler >> result: anObject [
	result := anObject
]
