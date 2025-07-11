Class {
	#name : #GtMcpStdioTransport,
	#superclass : #Object,
	#instVars : [
		'process',
		'stdout',
		'messages'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtMcpStdioTransport >> gtMessagesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ messages ];
		column: 'Method'
			text: [ :aMessage | aMessage at: 'method' ifAbsent: [ 'response' ] ];
		column: 'Body' text: [ :aMessage | aMessage ] weight: 3
]

{ #category : #'as yet unclassified' }
GtMcpStdioTransport >> initialize [
	super initialize.
	
	messages := OrderedCollection new
]

{ #category : #accessing }
GtMcpStdioTransport >> process [
	^ process
]

{ #category : #accessing }
GtMcpStdioTransport >> process: anObject [
	process := anObject.
	
	stdout := process asynchronousStdout
]

{ #category : #accessing }
GtMcpStdioTransport >> receiveResponse [
	| resultString ston value result |
	resultString := ''.
	[ resultString := resultString , stdout pollString.
	[ ston := STON reader on: resultString readStream.
	value := ston next.
	ston atEnd ] on: STONReaderError do: [ false ] ] whileFalse.
	result := STONJSON fromString: resultString.
	
	messages add: result.

	(result includesKey: 'error')
		ifTrue: [ self error: (result at: 'error') asString ].


	((result includesKey: 'method')
		and: [ (result at: 'method') = 'notifications/message' ])
		ifTrue: [ ^ self receiveResponse ].

	^ result
]

{ #category : #'as yet unclassified' }
GtMcpStdioTransport >> sendMessage: anObject [
	messages add: anObject.
	process stdin
		nextPutAll: (STONJSON toString: anObject);
		crlf
]

{ #category : #'as yet unclassified' }
GtMcpStdioTransport >> terminate [
	process kill
]
