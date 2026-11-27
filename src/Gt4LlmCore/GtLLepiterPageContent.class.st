"
I am the contents of a Lepiter page in one of the formats that getLepiterPageContents answers (GtLToolForLepiterPageContents). Each subclass is one format: it names itself with formatName and builds its JSON in llmJsonObject. I hold the page and compute the contents when they are asked for.
"
Class {
	#name : #GtLLepiterPageContent,
	#superclass : #Object,
	#instVars : [
		'page'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLLepiterPageContent class >> forFormat: aFormatName ifUnknown: anUnknownBlock [
	"Return the class of the format named aFormatName. anUnknownBlock gets an error domain object for any other name"

	^ self formatClasses
		detect: [ :each | each formatName = aFormatName ]
		ifNone: [ anUnknownBlock
				value: (GtLProblemDomainObject new
						errorMessage: 'Unknown format ' , aFormatName asString , ': the format is one of '
								, (', ' join: self formatNames);
						yourself) ]
]

{ #category : #accessing }
GtLLepiterPageContent class >> formatClasses [
	"Return the classes of the formats, in the order the tool lists them"

	^ {GtLLepiterPageMarkdownContent.
		GtLLepiterPageStructureContent.
		GtLLepiterPageStorageContent}
]

{ #category : #accessing }
GtLLepiterPageContent class >> formatName [
	"Return the name of my format, as the format argument of getLepiterPageContents gives it"

	^ self subclassResponsibility
]

{ #category : #accessing }
GtLLepiterPageContent class >> formatNames [
	^ self formatClasses collect: [ :each | each formatName ]
]

{ #category : #testing }
GtLLepiterPageContent class >> isAbstract [
	^ self == GtLLepiterPageContent
]

{ #category : #'instance creation' }
GtLLepiterPageContent class >> page: aPage [
	^ self new
		page: aPage;
		yourself
]

{ #category : #accessing }
GtLLepiterPageContent >> databaseId [
	"Return the id of the database of the page, or nil for an in-memory database, which has no id"

	^ GtLLepiterSnippetReference databaseIdOf: page database
]

{ #category : #accessing }
GtLLepiterPageContent >> formatName [
	^ self class formatName
]

{ #category : #views }
GtLLepiterPageContent >> gtContentsFor: aView [
	<gtView>
	page ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Contents';
		priority: 2;
		text: [ NeoJSONWriter toStringPretty: self llmJsonObject ]
]

{ #category : #views }
GtLLepiterPageContent >> gtLivePageFor: aView [
	<gtView>
	<gtLlmView>
	page ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Page';
		priority: 1;
		object: [ page ];
		view: #gtLiveFor:
]

{ #category : #views }
GtLLepiterPageContent >> llmContentsDataViewFor: aDataView [
	<gtLlmDataView>
	^ aDataView
		title: 'Page contents (' , self formatName , ')';
		jsonData: [ self llmJsonObject ]
]

{ #category : #accessing }
GtLLepiterPageContent >> llmJsonObject [
	"Return the JSON object of the page in my format"

	^ self subclassResponsibility
]

{ #category : #accessing }
GtLLepiterPageContent >> page [
	^ page
]

{ #category : #accessing }
GtLLepiterPageContent >> page: aPage [
	page := aPage
]

{ #category : #accessing }
GtLLepiterPageContent >> pageAttributes [
	"Return the title and ids that the markdown and structure formats start with"

	| json |
	json := OrderedDictionary new.
	json
		at: 'pageTitle' put: page title;
		at: 'pageUid' put: self pageUid.
	self databaseId ifNotNil: [ :anId | json at: 'databaseId' put: anId ].
	^ json
]

{ #category : #accessing }
GtLLepiterPageContent >> pageUid [
	"Return the page id in the form the tools take and answer (base 36)"

	^ page uid asString36
]

{ #category : #printing }
GtLLepiterPageContent >> printOn: aStream [
	aStream
		nextPutAll: self formatName;
		nextPutAll: ' of '.
	page
		ifNil: [ aStream nextPutAll: 'no page' ]
		ifNotNil: [ aStream print: page title ]
]
