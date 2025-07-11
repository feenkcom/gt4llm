Class {
	#name : #GtMcpStdioTransport,
	#superclass : #Object,
	#instVars : [
		'process',
		'stdout'
	],
	#category : #Gt4Llm
}

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
	| resultString ston value |
	resultString := ''.
	[ resultString := resultString , stdout pollString.
	[ ston := STON reader on: resultString readStream.
	value := ston next.
	ston atEnd ] on: STONReaderError do: [ false ] ] whileFalse.
	^ STONJSON fromString: resultString
]

{ #category : #'as yet unclassified' }
GtMcpStdioTransport >> sendMessage: anObject [
	process stdin
		nextPutAll: (STONJSON toString: anObject);
		crlf
]

{ #category : #'as yet unclassified' }
GtMcpStdioTransport >> terminate [
	process kill
]
