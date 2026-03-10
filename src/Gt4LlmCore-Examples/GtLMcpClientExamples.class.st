Class {
	#name : #GtLMcpClientExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'as yet unclassified' }
GtLMcpClientExamples >> clientListPrompts [
	<gtExample>
	| client |
	client := self simpleClientWithTransport.
	client transport
		addMessage: {'result' -> {'prompts' -> {}} asDictionary} asDictionary.

	self assert: client listPrompts size equals: 0.

	^ client
]

{ #category : #'as yet unclassified' }
GtLMcpClientExamples >> clientListResources [
	<gtExample>
	| client |
	client := self simpleClientWithTransport.
	client transport
		addMessage: {'result' -> {'resources' -> {}} asDictionary} asDictionary.

	self assert: client listResources size equals: 0.

	^ client
]

{ #category : #'as yet unclassified' }
GtLMcpClientExamples >> clientListTools [
	<gtExample>
	| client |
	client := self simpleClientWithTransport.
	client transport
		addMessage: {'result' -> {'tools' -> {}} asDictionary} asDictionary.

	self assert: client listTools size equals: 0.

	^ client
]

{ #category : #'as yet unclassified' }
GtLMcpClientExamples >> simpleClient [
	<gtExample>
	^ GtLMcpClient new
]

{ #category : #'as yet unclassified' }
GtLMcpClientExamples >> simpleClientWithTransport [
	<gtExample>
	^ GtLMcpClient new
		transport: (GtLMcpStaticTransport new
				messages: {{'result'
								-> {'capabilities'
											-> {'tools' -> {} asDictionary.
													'prompts' -> {} asDictionary.
													'resources' -> {} asDictionary} asDictionary} asDictionary}
							asDictionary}asOrderedCollection)
]
