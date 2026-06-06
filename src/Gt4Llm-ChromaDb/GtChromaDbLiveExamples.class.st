Class {
	#name : #GtChromaDbLiveExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#instVars : [
		'isLive'
	],
	#classVars : [
		'IsLive'
	],
	#category : #'Gt4Llm-ChromaDb-Examples'
}

{ #category : #accessing }
GtChromaDbLiveExamples class >> isLive [
	^ IsLive ifNil: [ false ]
]

{ #category : #accessing }
GtChromaDbLiveExamples class >> isLive: anObject [
	IsLive := anObject
]

{ #category : #examples }
GtChromaDbLiveExamples >> clientAddToCollection [
	<gtExample>
	| client result collection entity |

	self isLive ifFalse: [ ^ self ].
	collection := self clientCreateCollection.
	client := GtChromaDbClient new.
	entity := {
		'ids' -> #('id1' 'id2' 'id3').
		'documents' -> #('Doc 1' 'Doc 2' 'Doc 3').
		'embeddings' -> {
			{ 0.1. 0.2. 0.3. }.
			{ 0.4. 0.5. 0.6. }.
			{ 0.7. 0.8. 0.9. }.
			}.
		'metadatas' -> {
			{ 'db' -> 'Database1'. 'page' -> 'Page 1'. } asDictionary.
			{ 'db' -> 'Database2'. 'page' -> 'Page 2'. } asDictionary.
			{ 'db' -> 'Database3'. 'page' -> 'Page 3'. } asDictionary.
			}.
		'uris' -> {
			'lePageRef://lepiterRegistry/database1/page1'.
			'lePageRef://lepiterRegistry/database2/page2'.
			'lePageRef://lepiterRegistry/database3/page3'.
			}.
		} asDictionary.
	result := client 
		post: GtChromaDbAddCollectionRecordsEndpoint new
		parameters: {
			'tenant' -> collection tenant.
			'database' -> collection databaseName.
			'collectionId' -> collection id.
			} asDictionary
		entity: entity.
	^ collection
]

{ #category : #examples }
GtChromaDbLiveExamples >> clientCreateCollection [
	<gtExample>
	| client result |

	self isLive ifFalse: [ ^ self ].
	client := GtChromaDbClient new.
	result := client
		ensureCollectionNamed: self class name asString
		database: self clientGetDatabase.
	self assert: result class identicalTo: GtChromaDbCollection.
	self assert: result rawData keys asSet equals: #(#schema #database #log_position #id #configuration_json #metadata #version #tenant #dimension #name) asSet.
	^ result
]

{ #category : #examples }
GtChromaDbLiveExamples >> clientGetCollection [
	<gtExample>
	| client result collection |

	self isLive ifFalse: [ ^ self ].
	collection := self clientCreateCollection.
	client := GtChromaDbClient new.
	result := client
		collectionNamed: collection name
		database: self clientGetDatabase.
	self assert: result id equals: collection id.
	^ result
]

{ #category : #examples }
GtChromaDbLiveExamples >> clientGetCollectionCount [
	<gtExample>
	| client result collection |

	self isLive ifFalse: [ ^ self ].
	collection := self clientAddToCollection.
	client := GtChromaDbClient new.
	result := client 
		get: GtChromaDbGetCollectionCountEndpoint new
		parameters: {
			'tenant' -> collection tenant.
			'database' -> collection databaseName.
			'collectionId' -> collection id.
			} asDictionary.
	self assert: result > 0.
	^ result
]

{ #category : #examples }
GtChromaDbLiveExamples >> clientGetCollections [
	<gtExample>
	| client result database collection |

	self isLive ifFalse: [ ^ self ].
	database := self clientGetDatabases anyOne.
	client := GtChromaDbClient new.
	result := client 
		get: GtChromaDbGetCollectionsEndpoint new
		parameters: {
			'tenant' -> database tenant.
			'database' -> database name.
			} asDictionary
		query: {
			'limit' -> 100.
			} asDictionary.
	self assert: result class identicalTo: GtChromaDbCollections.
	self assert: result size > 0.
	collection := result anyOne.
	self assert: collection rawData keys asSet equals: #(#schema #database #log_position #id #configuration_json #metadata #version #tenant #dimension #name) asSet.
	^ result
]

{ #category : #examples }
GtChromaDbLiveExamples >> clientGetDatabase [
	<gtExample>
	| client database |

	self isLive ifFalse: [ ^ self ].
	client := GtChromaDbClient new.
	database := client 
		databaseNamed: self databaseName
		tenant: self tenant.
	self assert: database class identicalTo: GtChromaDbDatabase.
	^ database
]

{ #category : #examples }
GtChromaDbLiveExamples >> clientGetDatabases [
	<gtExample>
	| client identity result database |

	self isLive ifFalse: [ ^ self ].
	identity := self clientGetIdentity.
	client := GtChromaDbClient new.
	result := client 
		get: GtChromaDbGetDatabasesEndpoint new
		parameters: {
			'tenant' -> identity tenant.
			} asDictionary.
	self assert: result class identicalTo: GtChromaDbDatabases.
	self assert: result size > 0.
	database := result anyOne.
	self assert: database rawData keys asSet equals: #('id' 'name' 'tenant') asSet.
	^ result
]

{ #category : #examples }
GtChromaDbLiveExamples >> clientGetIdentity [
	<gtExample>
	| client result |

	self isLive ifFalse: [ ^ self ].
	client := GtChromaDbClient new.
	result := client get: GtChromaDbGetIdentityEndpoint new.
	self assert: result rawData keys asSet equals: #('user_id' 'tenant' 'databases') asSet.
	^ result
]

{ #category : #examples }
GtChromaDbLiveExamples >> clientQueryCollection [
	<gtExample>
	| client result collection entity |

	self isLive ifFalse: [ ^ self ].
	collection := self clientAddToCollection.
	client := GtChromaDbClient new.
	entity := {
		'include' -> { 'documents'. 'metadatas'. 'distances'. 'uris'. }.
		'n_results' -> 10.
		'query_embeddings' -> { { 0.5. 0.5. 0.5. }. }.
		'where' -> {
			'db' -> 'Database2'.
			} asDictionary.
		} asDictionary.
	result := client 
		post: GtChromaDbQueryCollectionEndpoint new
		parameters: {
			'tenant' -> collection tenant.
			'database' -> collection databaseName.
			'collectionId' -> collection id.
			} asDictionary
		entity: entity.
"	self assert: result > 0."
	^ result
]

{ #category : #examples }
GtChromaDbLiveExamples >> databaseName [

	^ 'default_database'
]

{ #category : #examples }
GtChromaDbLiveExamples >> getCollection [
	<gtExample>
	| client database result collection |

	self isLive ifFalse: [ ^ self ].
	collection := self clientCreateCollection.
	client := GtChromaDbClient new.
	database := client databaseNamed: self databaseName.
	result := database ensureCollectionNamed: self class name asString.
	self assert: result id equals: collection id.
	^ result
]

{ #category : #accessing }
GtChromaDbLiveExamples >> isLive [
	^ isLive ifNil: [ self class isLive ]
]

{ #category : #accessing }
GtChromaDbLiveExamples >> isLive: anObject [
	isLive := anObject
]

{ #category : #accessing }
GtChromaDbLiveExamples >> tenant [

	^ 'default_tenant'
]
