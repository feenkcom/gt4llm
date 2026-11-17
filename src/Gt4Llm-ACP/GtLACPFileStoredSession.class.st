"
I provide the shared lazy byte snapshot, optional UTF-8 text, record parsing and cache invalidation for file-backed stored sessions. Subclasses supply the file and construct their domain record wrappers.
"
Class {
	#name : #GtLACPFileStoredSession,
	#superclass : #GtLACPStoredSession,
	#instVars : [
		'rawBytes',
		'rawData',
		'allRecords',
		'parseIssues'
	],
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #accessing }
GtLACPFileStoredSession >> allRecords [
	^ allRecords ifNil: [ allRecords := self parseRecords ]
]

{ #category : #accessing }
GtLACPFileStoredSession >> file [
	^ self subclassResponsibility
]

{ #category : #testing }
GtLACPFileStoredSession >> hasParsedRecords [
	^ allRecords isNotNil
]

{ #category : #testing }
GtLACPFileStoredSession >> hasRawBytes [
	^ rawBytes isNotNil
]

{ #category : #testing }
GtLACPFileStoredSession >> hasRawData [
	^ rawData isNotNil
]

{ #category : #initialization }
GtLACPFileStoredSession >> initialize [
	super initialize.
	parseIssues := OrderedCollection new
]

{ #category : #private }
GtLACPFileStoredSession >> newIssueAt: aLine description: aString [
	^ GtLACPStoredSessionReadIssue new
		file: self file;
		lineNumber: aLine;
		description: aString;
		yourself
]

{ #category : #private }
GtLACPFileStoredSession >> parseRecords [
	| result lineNumber sourceFile |
	result := OrderedCollection new.
	lineNumber := 0.
	sourceFile := self file.
	self rawData
		linesDo: [ :line | 
			lineNumber := lineNumber + 1.
			line
				ifNotEmpty: [ [ | data record |
					data := STONJSON fromString: line.
					(data isKindOf: Dictionary)
						ifFalse: [ self error: 'Expected a JSON object' ].
					record := self recordFrom: data.
					record
						session: self;
						file: sourceFile;
						lineNumber: lineNumber.
					result add: record ]
						on: Error
						do: [ :error | parseIssues add: (self newIssueAt: lineNumber description: error messageText) ] ] ].
	^ result
]

{ #category : #accessing }
GtLACPFileStoredSession >> rawBytes [
	^ rawBytes
		ifNil: [ rawBytes := self file
					ifNil: [ #[] ]
					ifNotNil: [ :aFile | 
						[ aFile binaryContents ]
							on: Error
							do: [ :error | 
								parseIssues add: (self newIssueAt: nil description: error messageText).
								#[] ] ] ]
]

{ #category : #accessing }
GtLACPFileStoredSession >> rawData [
	^ rawData
		ifNil: [ rawData := [ self rawBytes utf8Decoded ]
					on: Error
					do: [ :error | 
						parseIssues add: (self newIssueAt: nil description: error messageText).
						'' ] ]
]

{ #category : #accessing }
GtLACPFileStoredSession >> rawData: aString [
	self read.
	rawData := aString.
	rawBytes := aString utf8Encoded
]

{ #category : #reading }
GtLACPFileStoredSession >> read [
	rawBytes := nil.
	rawData := nil.
	allRecords := nil.
	directory := nil.
	createdAt := nil.
	updatedAt := nil.
	title := nil.
	parseIssues removeAll.
	^ self
]

{ #category : #accessing }
GtLACPFileStoredSession >> recordCount [
	^ self allRecords size
]

{ #category : #private }
GtLACPFileStoredSession >> recordFrom: aDictionary [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLACPFileStoredSession >> recordKinds [
	| counts |
	counts := Dictionary new.
	self allRecords
		do: [ :record | 
			| kind |
			kind := record kind.
			kind isString ifFalse: [ kind := 'invalid type' ].
			counts at: kind put: (counts at: kind ifAbsent: [ 0 ]) + 1 ].
	^ counts
]
