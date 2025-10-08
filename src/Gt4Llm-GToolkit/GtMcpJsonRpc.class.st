Class {
	#name : #GtMcpJsonRpc,
	#superclass : #Object,
	#instVars : [
		'version',
		'id',
		'method',
		'params',
		'result'
	],
	#category : #'Gt4Llm-GToolkit-Mcp'
}

{ #category : #'as yet unclassified' }
GtMcpJsonRpc class >> on: aDict [
	^ self new
		version: (aDict at: 'jsonrpc');
		id: (aDict at: 'id' ifAbsent: [nil]);
		method: (aDict at: 'method');
		params: (aDict at: 'params' ifAbsent: [nil])
]

{ #category : #'as yet unclassified' }
GtMcpJsonRpc >> asDict [
	| dict |
	dict := {'jsonrpc' -> self version} asDictionary.

	self id ifNotNil: [ dict at: 'id' put: self id ].
	self method ifNotNil: [ dict at: 'method' put: self method ].
	self params ifNotNil: [ dict at: 'params' put: self params ].
	self result ifNotNil: [ dict at: 'result' put: self result ].

	^ dict
]

{ #category : #'as yet unclassified' }
GtMcpJsonRpc >> asJson [
	^ STONJSON toString: self asDict
]

{ #category : #'as yet unclassified' }
GtMcpJsonRpc >> asZnResponse [
	^ ZnResponse ok: (ZnStringEntity json: self asJson)
]

{ #category : #accessing }
GtMcpJsonRpc >> id [
	^ id
]

{ #category : #accessing }
GtMcpJsonRpc >> id: anObject [
	id := anObject
]

{ #category : #'as yet unclassified' }
GtMcpJsonRpc >> initialize [
	super initialize.
	
	version := '2.0'
]

{ #category : #accessing }
GtMcpJsonRpc >> method [
	^ method
]

{ #category : #accessing }
GtMcpJsonRpc >> method: anObject [
	method := anObject
]

{ #category : #accessing }
GtMcpJsonRpc >> params [
	^ params
]

{ #category : #accessing }
GtMcpJsonRpc >> params: anObject [
	params := anObject
]

{ #category : #accessing }
GtMcpJsonRpc >> result [
	^ result
]

{ #category : #accessing }
GtMcpJsonRpc >> result: anObject [
	result := anObject
]

{ #category : #accessing }
GtMcpJsonRpc >> version [
	^ version
]

{ #category : #accessing }
GtMcpJsonRpc >> version: anObject [
	version := anObject
]
