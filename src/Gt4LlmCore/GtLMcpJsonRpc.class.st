Class {
	#name : #GtLMcpJsonRpc,
	#superclass : #Object,
	#instVars : [
		'version',
		'id',
		'method',
		'params',
		'result'
	],
	#category : 'Gt4LlmCore-Mcp'
}

{ #category : #'as yet unclassified' }
GtLMcpJsonRpc class >> on: aDict [
	^ self new
		version: (aDict at: 'jsonrpc');
		id: (aDict at: 'id' ifAbsent: [nil]);
		method: (aDict at: 'method');
		params: (aDict at: 'params' ifAbsent: [nil])
]

{ #category : #'as yet unclassified' }
GtLMcpJsonRpc >> asDict [
	| dict |
	dict := {'jsonrpc' -> self version} asDictionary.

	self id ifNotNil: [ dict at: 'id' put: self id ].
	self method ifNotNil: [ dict at: 'method' put: self method ].
	self params ifNotNil: [ dict at: 'params' put: self params ].
	self result ifNotNil: [ dict at: 'result' put: self result ].

	^ dict
]

{ #category : #'as yet unclassified' }
GtLMcpJsonRpc >> asJson [
	^NeoJSONWriter toString: self asDict
]

{ #category : #'as yet unclassified' }
GtLMcpJsonRpc >> asZnResponse [
	^ ZnResponse ok: (ZnStringEntity json: self asJson)
]

{ #category : #accessing }
GtLMcpJsonRpc >> id [
	^ id
]

{ #category : #accessing }
GtLMcpJsonRpc >> id: anObject [
	id := anObject
]

{ #category : #'as yet unclassified' }
GtLMcpJsonRpc >> initialize [
	super initialize.
	
	version := '2.0'
]

{ #category : #accessing }
GtLMcpJsonRpc >> method [
	^ method
]

{ #category : #accessing }
GtLMcpJsonRpc >> method: anObject [
	method := anObject
]

{ #category : #accessing }
GtLMcpJsonRpc >> params [
	^ params
]

{ #category : #accessing }
GtLMcpJsonRpc >> params: anObject [
	params := anObject
]

{ #category : #accessing }
GtLMcpJsonRpc >> result [
	^ result
]

{ #category : #accessing }
GtLMcpJsonRpc >> result: anObject [
	result := anObject
]

{ #category : #accessing }
GtLMcpJsonRpc >> version [
	^ version
]

{ #category : #accessing }
GtLMcpJsonRpc >> version: anObject [
	version := anObject
]
