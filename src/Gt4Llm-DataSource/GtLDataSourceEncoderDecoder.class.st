Class {
	#name : #GtLDataSourceEncoderDecoder,
	#superclass : #Object,
	#instVars : [
		'chat',
		'jsonEncoder',
		'jsonDecoder'
	],
	#category : #'Gt4Llm-DataSource-Model'
}

{ #category : #'encoding - decoding' }
GtLDataSourceEncoderDecoder class >> loadClientHistoryFrom: aFileReference [
	| encoder history |

	encoder := self new.
	aFileReference asFileReference readStreamDo: [ :stream |
		self loadClientHistoryFromStream: stream ].
	^ history
]

{ #category : #'encoding - decoding' }
GtLDataSourceEncoderDecoder class >> loadClientHistoryFromStream: aReadStream [
	| encoder history |

	encoder := self new.
	history := GtLRequestHistory streamContents: [ :aStream |
		[ aReadStream atEnd ] whileFalse:
				[ aStream nextPut: (encoder decodeRequestResponseOn: aReadStream) ] ].
	^ history
]

{ #category : #'encoding - decoding' }
GtLDataSourceEncoderDecoder class >> saveClientHistory: aCollection to: aFileReference [
	| encoder |

	encoder := self new.
	aFileReference asFileReference writeStreamDo: [ :stream |
		aCollection do: [ :aGtRequestResponse |
			encoder encode: aGtRequestResponse on: stream ] ].
]

{ #category : #accessing }
GtLDataSourceEncoderDecoder >> chat [
	^ chat
]

{ #category : #accessing }
GtLDataSourceEncoderDecoder >> chat: anObject [
	chat := anObject
]

{ #category : #'encoding - decoding' }
GtLDataSourceEncoderDecoder >> decodeRequestOn: aStream [

	^ (self jsonDecoder on: aStream) nextAs: ZnRequest
]

{ #category : #'encoding - decoding' }
GtLDataSourceEncoderDecoder >> decodeRequestResponseOn: aStream [

	^ (self jsonDecoder on: aStream) nextAs: GtLRequestResponse
]

{ #category : #'encoding - decoding' }
GtLDataSourceEncoderDecoder >> decodeResponseOn: aStream [

	^ (self jsonDecoder on: aStream) nextAs: ZnResponse
]

{ #category : #'encoding - decoding' }
GtLDataSourceEncoderDecoder >> encode: aZnMessage on: aStream [

	^ (self jsonEncoder on: aStream)
		nextPut: aZnMessage
]

{ #category : #initialization }
GtLDataSourceEncoderDecoder >> initialize [

	super initialize.

	jsonEncoder := NeoJSONWriter new.
	jsonEncoder prettyPrint: true.
	self initializeJsonMapper: jsonEncoder.

	jsonDecoder := NeoJSONReader new.
	self initializeJsonMapper: jsonDecoder.
]

{ #category : #initialization }
GtLDataSourceEncoderDecoder >> initializeJsonMapper: aJsonMapper [

	self initializeZnRequestMapper: aJsonMapper.
	self initializeZnResponseMapper: aJsonMapper.
	self initializeRequestResponseMapper: aJsonMapper.
]

{ #category : #initialization }
GtLDataSourceEncoderDecoder >> initializeRequestResponseMapper: aJsonMapper [

	aJsonMapper for: GtLRequestResponse do: [ :mapping |
		(mapping mapAccessor: #request) valueSchema: ZnRequest.
		(mapping mapAccessor: #response) 
			valueSchema: ZnResponse;
			setter: [ :aGtLRequestResponse :aZnResponse | 
				aGtLRequestResponse 
					response: aZnResponse;
					result: aZnResponse asGtJson jsonObject. ].
		 ].
]

{ #category : #initialization }
GtLDataSourceEncoderDecoder >> initializeZnMessageMapping: mapping [

		mapping mapProperty: #headers
			getter: [ :znRequest | znRequest headers headers asDictionary ]
			setter: [ :znRequest :jsonObject | 
				jsonObject keysAndValuesDo: [ :key :value |
					znRequest headers at: key put: value ] ].
		mapping mapProperty: #entity
			getter: [ :znRequest | 
				self assert: znRequest entity contentType = ZnMimeType applicationJson.
				(NeoJSONReader on: znRequest contents readStream) next ]
			setter: [ :znRequest :jsonObject | 
				znRequest entity: (ZnStringEntity json:
					(NeoJSONWriter toString: jsonObject)) ].
]

{ #category : #initialization }
GtLDataSourceEncoderDecoder >> initializeZnRequestMapper: aJsonMapper [

	aJsonMapper for: ZnRequest do: [ :mapping |
		self initializeZnMessageMapping: mapping.
		mapping mapProperty: #requestLine
			getter: [ :znRequest | | requestLine |
				requestLine := znRequest requestLine.
				{
					'method' -> requestLine method.
					'uri' -> requestLine uri asString.
					'version' -> requestLine version
				} asDictionary ]
			setter: [ :znRequest :jsonObject | 
				znRequest requestLine: (ZnRequestLine new
					method: (jsonObject at: 'method');
					uri: (jsonObject at: 'uri') asZnUrl;
					version: (jsonObject at: 'version'))] ].
]

{ #category : #initialization }
GtLDataSourceEncoderDecoder >> initializeZnResponseMapper: aJsonMapper [

	aJsonMapper for: ZnResponse do: [ :mapping |
		self initializeZnMessageMapping: mapping.
		mapping mapProperty: #statusLine
			getter: [ :znResponse | | statusLine |
				statusLine := znResponse statusLine.
				{
					'code' -> statusLine code.
					'reason' -> statusLine reason.
					'version' -> statusLine version
				} asDictionary ]
			setter: [ :znResponse :jsonObject | 
				znResponse statusLine: (ZnStatusLine new
					code: (jsonObject at: 'code');
					reason: (jsonObject at: 'reason');
					version: (jsonObject at: 'version'))] ].
]

{ #category : #accessing }
GtLDataSourceEncoderDecoder >> jsonDecoder [

	^ jsonDecoder
]

{ #category : #accessing }
GtLDataSourceEncoderDecoder >> jsonEncoder [

	^ jsonEncoder
]
