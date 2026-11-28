"
I am the structure format of a Lepiter page: the page title and ids, and the tree of its snippets. Each snippet has its snippetUid, its type and its own attributes as LeJsonV4 stores them, without the metadata every snippet carries (see metadataKeys) and without the attributes whose value is the default of a new snippet of the same class. The ids are in the form the snippet tools take: pageUid and databaseId in base 36, snippetUid in base 64. Use me when a page might be edited.
"
Class {
	#name : #GtLLepiterPageStructureContent,
	#superclass : #GtLLepiterPageContent,
	#instVars : [
		'defaultAttributesByClass'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLLepiterPageStructureContent class >> formatName [
	^ 'structure'
]

{ #category : #testing }
GtLLepiterPageStructureContent class >> isMetadataKey: aKey [
	"Return whether aKey is a key of the format (__type, __schema) or of an attribute that every snippet has"

	^ (aKey beginsWith: '__') or: [ self metadataKeys includes: aKey ]
]

{ #category : #accessing }
GtLLepiterPageStructureContent class >> metadataKeys [
	"Return the LeJsonV4 keys of the attributes that every snippet has, as LeSnippet maps them (uid, children, create and edit time and email), which the structure leaves out: the uid is given as snippetUid and the children as a list. The keys of the format itself, which start with __ (__type, __schema), are left out too (see isMetadataKey:)"

	^ (LeSnippet leJsonV4AttributeMapping collect: [ :each | each value asString ])
		asArray
]

{ #category : #private }
GtLLepiterPageStructureContent >> defaultAttributesOf: aSnippetClass [
	"Return the attributes of a new snippet of aSnippetClass. A class whose new snippets cannot be serialized has no defaults: all the attributes of its snippets are kept"

	defaultAttributesByClass ifNil: [ defaultAttributesByClass := Dictionary new ].
	^ defaultAttributesByClass
		at: aSnippetClass
		ifAbsentPut: [ [ self storedAttributesOf: aSnippetClass new ]
				on: Error
				do: [ :anError | Dictionary new ] ]
]

{ #category : #private }
GtLLepiterPageStructureContent >> isOwnAttribute: aKey withValue: aValue amongDefaults: theDefaultAttributes [
	"An attribute is kept unless it is metadata or has the value of a new snippet"

	(self class isMetadataKey: aKey) ifTrue: [ ^ false ].
	^ (theDefaultAttributes includesKey: aKey) not
		or: [ (theDefaultAttributes at: aKey) ~= aValue ]
]

{ #category : #accessing }
GtLLepiterPageStructureContent >> llmJsonObject [
	^ self pageAttributes
		at: 'snippets' put: (self structuresOfSnippets: page children);
		yourself
]

{ #category : #private }
GtLLepiterPageStructureContent >> storedAttributesOf: aSnippet [
	"Return the attributes of aSnippet as LeJsonV4 stores them"

	^ NeoJSONReader fromString: (LeJsonV4 uniqueInstance serialize: aSnippet)
]

{ #category : #private }
GtLLepiterPageStructureContent >> structureOfSnippet: aSnippet [
	"Return the snippetUid, the type, the own attributes in the order of their names, and the children when there are some"

	| attributes defaults json children |
	attributes := self storedAttributesOf: aSnippet.
	defaults := self defaultAttributesOf: aSnippet class.
	json := OrderedDictionary new.
	json
		at: 'snippetUid' put: aSnippet uidString;
		at: 'type' put: (attributes at: '__type' ifAbsent: [ nil ]).
	attributes keys asSortedCollection
		do: [ :aKey | 
			| aValue |
			aValue := attributes at: aKey.
			(self
				isOwnAttribute: aKey
				withValue: aValue
				amongDefaults: defaults) ifTrue: [ json at: aKey put: aValue ] ].
	children := self structuresOfSnippets: aSnippet children.
	children ifNotEmpty: [ json at: 'children' put: children ].
	^ json
]

{ #category : #private }
GtLLepiterPageStructureContent >> structuresOfSnippets: aCollectionOfSnippets [
	^ aCollectionOfSnippets asArray
		collect: [ :each | self structureOfSnippet: each ]
]
