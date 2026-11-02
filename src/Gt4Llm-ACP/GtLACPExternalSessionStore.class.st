"
I discover native agent sessions from a configurable storage root. Concrete stores interpret their own formats. My Sessions view answers what was found; Read problems explains incomplete discovery. Reading never starts or resumes an agent.
"
Class {
	#name : #GtLACPExternalSessionStore,
	#superclass : #GtLACPObject,
	#instVars : [
		'rootDirectory',
		'sessions',
		'issues'
	],
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #'instance creation' }
GtLACPExternalSessionStore class >> on: aDirectory [
 ^ self new rootDirectory: aDirectory; yourself
]

{ #category : #accessing }
GtLACPExternalSessionStore >> agentName [
 self subclassResponsibility
]

{ #category : #reading }
GtLACPExternalSessionStore >> dateFrom: aValue file: aFile line: aLine [
 aValue ifNil: [ ^ nil ].
 ^ [ (DateAndTime fromString: aValue) asUTC ]
  on: Error do: [ :error |
   self issueFor: aFile line: aLine description: 'Invalid timestamp: ', aValue printString.
   nil ]
]

{ #category : #defaults }
GtLACPExternalSessionStore >> defaultDirectory [
 self subclassResponsibility
]

{ #category : #reading }
GtLACPExternalSessionStore >> directory: aString for: aSession file: aFile line: aLine [
 | project |
 aString isString ifFalse: [ self error: 'Project directory must be a string' ].
 aString ifEmpty: [ self error: 'Project directory must not be empty' ].
 project := aString asFileReference.
 project isAbsolute ifFalse: [ self error: 'Recorded project directory must be absolute' ].
 aSession directory ifNotNil: [ :previous |
  previous = project ifFalse: [
   self issueFor: aFile line: aLine description: 'Conflicting project directory; earlier source retained'.
   ^ self ] ].
 aSession directory: project
]

{ #category : #querying }
GtLACPExternalSessionStore >> forDirectory: aDirectory [
 ^ GtLACPStoredSessionQuery new
  store: self; directory: aDirectory asFileReference asAbsolute; yourself
]

{ #category : #views }
GtLACPExternalSessionStore >> gtIssuesFor: aView [
 <gtView>
 ^ aView columnedList title: 'Read problems'; priority: 10; items: [ issues ];
  column: 'File' text: [ :issue | issue file fullName ];
  column: 'Line' text: [ :issue | issue lineNumber ifNil: [ '' ] ifNotNil: #asString ] width: 50;
  column: 'Reason' text: #description
]

{ #category : #views }
GtLACPExternalSessionStore >> gtSessionsFor: aView [
 <gtView>
 ^ GtLACPStoredSession sessionsView: aView items: [ self sessions ]
]

{ #category : #initialization }
GtLACPExternalSessionStore >> initialize [
 super initialize.
 rootDirectory := self defaultDirectory.
 sessions := Dictionary new.
 issues := OrderedCollection new
]

{ #category : #reading }
GtLACPExternalSessionStore >> issueFor: aFile line: aLine description: aString [
 issues add: (GtLACPStoredSessionReadIssue new
  file: aFile; lineNumber: aLine; description: aString; yourself)
]

{ #category : #accessing }
GtLACPExternalSessionStore >> issues [
 ^ issues
]

{ #category : #reading }
GtLACPExternalSessionStore >> metadataFrom: aDictionary keys: keys [
 | selected |
 selected := Dictionary new.
 keys do: [ :key | aDictionary at: key ifPresent: [ :value | selected at: key put: value ] ].
 ^ selected
]

{ #category : #printing }
GtLACPExternalSessionStore >> printOn: aStream [
 aStream nextPutAll: self agentName; nextPutAll: ' sessions at '; nextPutAll: rootDirectory fullName
]

{ #category : #reading }
GtLACPExternalSessionStore >> read [
 sessions removeAll.
 issues removeAll.
 rootDirectory isDirectory ifFalse: [
  self issueFor: rootDirectory line: nil description: 'Storage directory is absent'.
  ^ self ].
 [ self readSessions ] on: Error do: [ :error |
  self issueFor: rootDirectory line: nil description: error messageText ].
 ^ self
]

{ #category : #reading }
GtLACPExternalSessionStore >> readJsonLines: aFile limit: aLimit do: aBlock [
 | lineNumber |
 lineNumber := 0.
 [ aFile readStreamDo: [ :stream |
  [ stream atEnd not and: [ lineNumber < aLimit ] ] whileTrue: [
   | line |
   lineNumber := lineNumber + 1.
   line := stream nextLine.
   line ifNotEmpty: [
    [ | record |
     record := STONJSON fromString: line.
     (record isKindOf: Dictionary) ifFalse: [ self error: 'Expected a JSON object' ].
     (aBlock value: record value: lineNumber) ifTrue: [ ^ self ] ]
      on: Error do: [ :error |
       self issueFor: aFile line: lineNumber description: error messageText ] ] ] ] ]
  on: Error do: [ :error |
   self issueFor: aFile line: lineNumber description: error messageText ]
]

{ #category : #reading }
GtLACPExternalSessionStore >> readSessions [
 self subclassResponsibility
]

{ #category : #accessing }
GtLACPExternalSessionStore >> rootDirectory [
 ^ rootDirectory
]

{ #category : #accessing }
GtLACPExternalSessionStore >> rootDirectory: aDirectory [
 rootDirectory := aDirectory asFileReference
]

{ #category : #reading }
GtLACPExternalSessionStore >> sessionAt: anId [
 (anId isString and: [ anId notEmpty ]) ifFalse: [ self error: 'Session ID must be a nonempty string' ].
 ^ sessions at: anId ifAbsentPut: [
  GtLACPStoredSession new store: self; sessionId: anId; yourself ]
]

{ #category : #accessing }
GtLACPExternalSessionStore >> sessions [
 ^ sessions values sorted: [ :a :b |
  a sortKey = b sortKey ifTrue: [ a sessionId <= b sessionId ]
   ifFalse: [ a sortKey > b sortKey ] ]
]

{ #category : #reading }
GtLACPExternalSessionStore >> sourceFile: aFile format: aSymbol metadata: aDictionary [
 ^ GtLACPStoredSessionSource new file: aFile; format: aSymbol; metadata: aDictionary; yourself
]
