"
I am the content of a non-textual snippet other than an example snippet (picture, Wardley map, ...): its specific state (`extractSpecificState`, without uid, children and the create and edit metadata), as name -> JSON string associations, sorted by name. The JSON string is what `LeJsonV4 uniqueInstance serialize:` writes for the attribute value, computed when the snapshot is taken, so later changes to the snippet do not affect me.

My `contentString` has one line per attribute, `name: json`, and I am diffed by lines.

An example snippet is recorded as its annotation instead ({{gtMethod:LeExampleSnippet>>#gtLlmSnippetContent}}): that text names all its attributes that are not at their default, and it is the text its refactoring changes give in a preview.
"
Class {
	#name : #GtLLepiterSnippetPropertiesContent,
	#superclass : #GtLLepiterSnippetContent,
	#instVars : [
		'properties'
	],
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLLepiterSnippetPropertiesContent class >> fromSnippet: aSnippet [
	"Keep the JSON that Lepiter writes for each specific attribute. Without specific attributes, or if writing one fails, fall back to a string content of a copy of contentAsString"

	| aState associations |
	associations := OrderedCollection new.
	[ aState := aSnippet extractSpecificState.
	aState
		attributesDo: [ :each | 
			associations
				add: each attributeName asString
						-> (LeJsonV4 uniqueInstance serialize: each attributeValue) asString ] ]
		on: Error
		do: [ :anError | 
			^ GtLLepiterSnippetStringContent
				string: aSnippet contentAsString
				diffKind: #lines ].
	associations
		ifEmpty: [ ^ GtLLepiterSnippetStringContent
				string: aSnippet contentAsString
				diffKind: #lines ].
	^ self new
		properties: (associations asArray sort: [ :a :b | a key <= b key ]);
		yourself
]

{ #category : #accessing }
GtLLepiterSnippetPropertiesContent >> contentString [
	^ String
		streamContents: [ :aStream | 
			self properties
				do: [ :each | 
					aStream
						nextPutAll: each key;
						nextPutAll: ': ';
						nextPutAll: each value ]
				separatedBy: [ aStream cr ] ]
]

{ #category : #views }
GtLLepiterSnippetPropertiesContent >> gtPropertiesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Properties';
		priority: 4;
		items: [ self properties ];
		column: 'Name'
			text: [ :each | each key ]
			width: 180;
		column: 'JSON' text: [ :each | each value ]
]

{ #category : #accessing }
GtLLepiterSnippetPropertiesContent >> properties [
	"Return the specific attributes as name -> JSON string associations, sorted by name"

	^ properties ifNil: [ #() ]
]

{ #category : #accessing }
GtLLepiterSnippetPropertiesContent >> properties: aCollectionOfAssociations [
	properties := aCollectionOfAssociations asArray
]

{ #category : #accessing }
GtLLepiterSnippetPropertiesContent >> valueOf: anAttributeName [
	"Return the JSON string of an attribute, or nil"

	^ self properties
		detect: [ :each | each key = anAttributeName ]
		ifFound: [ :each | each value ]
		ifNone: [ nil ]
]
