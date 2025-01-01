Class {
	#name : #GtLlmModelFileExamples,
	#superclass : #Object,
	#traits : 'TGtExampleAssertable',
	#classTraits : 'TGtExampleAssertable classTrait',
	#category : #'Gt4Llm-Examples'
}

{ #category : #'as yet unclassified' }
GtLlmModelFileExamples >> modelfile [
	<gtExample>
	| modelfile |
	modelfile := GtLlmModelFile new.

	self assert: modelfile content equals: ''.
	self assert: modelfile directives isEmpty.

	^ modelfile
]

{ #category : #'as yet unclassified' }
GtLlmModelFileExamples >> modelfileWithMessages [
	<gtExample>
	| modelfile |
	modelfile := self modelfile.

	modelfile addMessage: GtLlmMessageExamples new userMessage.
	modelfile addMessage: GtLlmMessageExamples new assistantMessage.

	self assert: modelfile directives size equals: 2.

	^ modelfile
]

{ #category : #'as yet unclassified' }
GtLlmModelFileExamples >> modelfileWithSystem [
	<gtExample>
	| modelfile |
	modelfile := self modelfile.

	modelfile system: 'You are a helpfule assistant'.

	self assert: modelfile directives size equals: 1.

	^ modelfile
]
