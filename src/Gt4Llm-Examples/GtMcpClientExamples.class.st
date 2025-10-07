Class {
	#name : #GtMcpClientExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Examples'
}

{ #category : #'as yet unclassified' }
GtMcpClientExamples >> clientListPrompts [
	<gtExample>
	| client |
	client := self simpleClientWithTransport.
	client transport
		addMessage: {'result' -> {'prompts' -> {}} asDictionary} asDictionary.

	self assert: client listPrompts size equals: 0.

	^ client
]

{ #category : #'as yet unclassified' }
GtMcpClientExamples >> clientListResources [
	<gtExample>
	| client |
	client := self simpleClientWithTransport.
	client transport
		addMessage: {'result' -> {'resources' -> {}} asDictionary} asDictionary.

	self assert: client listResources size equals: 0.

	^ client
]

{ #category : #'as yet unclassified' }
GtMcpClientExamples >> clientListTools [
	<gtExample>
	| client |
	client := self simpleClientWithTransport.
	client transport
		addMessage: {'result' -> {'tools' -> {}} asDictionary} asDictionary.

	self assert: client listTools size equals: 0.

	^ client
]

{ #category : #'as yet unclassified' }
GtMcpClientExamples >> simpleClient [
	<gtExample>
	^ GtMcpClient new
]

{ #category : #'as yet unclassified' }
GtMcpClientExamples >> simpleClientWithTransport [
	<gtExample>
	^ GtMcpClient new
		transport: (GtMcpStaticTransport new
				messages: {{'result'
								-> {'capabilities'
											-> {'tools' -> {} asDictionary.
													'prompts' -> {} asDictionary.
													'resources' -> {} asDictionary} asDictionary} asDictionary}
							asDictionary}asOrderedCollection)
]
