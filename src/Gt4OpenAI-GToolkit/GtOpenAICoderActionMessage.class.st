Class {
	#name : #GtOpenAICoderActionMessage,
	#superclass : #GtOpenAIObjectMessage,
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> instanceClass [
	^ self chat serializer instance content behavior
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> methodCode [
	^ self chat serializer instance content compiledMethod sourceCode
]

{ #category : #'as yet unclassified' }
GtOpenAICoderActionMessage >> selfObject [
	^ self chat serializer instance content selfObject
]
