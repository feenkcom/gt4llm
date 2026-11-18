"
I model a stored Claude Code session using a lazy UTF-8 byte snapshot. Browsing scans ASCII field markers in bytes and decodes only candidate metadata lines. Derived title, directory and timestamp are cached. rawData decodes the full snapshot only on explicit demand; full records and diagnostics remain lazy. The list therefore neither decodes the complete transcript nor parses conversation records. Both paths use the same immutable byte snapshot until read invalidates the snapshot and all derived caches. Optional custom-title sidecar evidence is loaded lazily.
"
Class {
	#name : #GtLACPClaudeCodeStoredSession,
	#superclass : #GtLACPFileStoredSession,
	#instVars : [
		'file',
		'sidecarRecords',
		'metadataRecords'
	],
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #'instance creation' }
GtLACPClaudeCodeStoredSession class >> on: aFile [
	^ self new
		store: GtLACPClaudeCodeSessionStore new;
		sessionId: aFile basenameWithoutExtension;
		file: aFile;
		yourself
]

{ #category : #accessing }
GtLACPClaudeCodeStoredSession >> createdAt [
	file ifNil: [ ^ super createdAt ].
	^ createdAt
		ifNil: [ createdAt := self directoryRecord
					ifNotNil: [ :record | 
						(record rawData at: 'timestamp' ifAbsent: [ nil ])
							ifNotNil: [ :timestamp | [ (DateAndTime fromString: timestamp) asUTC ] on: Error do: [ :error | nil ] ] ] ]
]

{ #category : #accessing }
GtLACPClaudeCodeStoredSession >> directory [
	file ifNil: [ ^ super directory ].
	^ directory
		ifNil: [ directory := self directoryRecord
					ifNotNil: [ :record | [ self directoryFromRecord: record ] on: Error do: [ :error | nil ] ] ]
]

{ #category : #private }
GtLACPClaudeCodeStoredSession >> directoryFromRecord: aRecord [
	| path |
	path := aRecord directory.
	path isString ifFalse: [ self error: 'Project directory must be a string' ].
	path ifEmpty: [ self error: 'Project directory must not be empty' ].
	path := path asFileReference.
	path isAbsolute
		ifFalse: [ self error: 'Recorded project directory must be absolute' ].
	^ path
]

{ #category : #accessing }
GtLACPClaudeCodeStoredSession >> directoryRecord [
	^ self metadataRecords
		detect: [ :record | record hasDirectory and: [ record belongsToSession ] ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtLACPClaudeCodeStoredSession >> file [
	^ file
]

{ #category : #accessing }
GtLACPClaudeCodeStoredSession >> file: aFile [
	file := aFile.
	self read
]

{ #category : #'gt - views' }
GtLACPClaudeCodeStoredSession >> gtIssuesFor: aView [
	"What prevented metadata from being read or associated with this session?"

	<gtView>
	^ aView columnedList
		title: 'Read problems';
		priority: 15;
		items: [ self issues ];
		column: 'File' text: [ :issue | issue file fullName ];
		column: 'Line' text: [ :issue | issue lineNumber ifNil: [ '' ] ];
		column: 'Reason' text: #description
]

{ #category : #'gt - views' }
GtLACPClaudeCodeStoredSession >> gtKindsFor: aView [
	"What kinds of records occur in the JSONL snapshot, including those without metadata?"

	<gtView>
	^ aView columnedList
		title: 'Record kinds';
		priority: 10;
		items: [ self recordKinds associations sorted: [ :a :b | a key <= b key ] ];
		column: 'Kind' text: #key;
		column: 'Count' text: #value
]

{ #category : #'gt - views' }
GtLACPClaudeCodeStoredSession >> gtRawDataFor: aView [
	"What exact JSONL snapshot do the properties derive from?"

	<gtView>
	^ aView textEditor
		title: 'Raw data';
		priority: 30;
		text: [ self rawData ]
]

{ #category : #'gt - views' }
GtLACPClaudeCodeStoredSession >> gtRecordsFor: aView [
	"Which metadata records were retained, where did each come from, and which supplies the directory?"

	<gtView>
	^ aView columnedList
		title: 'Metadata records';
		priority: 5;
		items: [ self records ];
		column: 'Line' text: [ :record | record lineNumber ifNil: [ 'sidecar' ] ];
		column: 'Kind' text: #kind;
		column: 'Session matches' text: #belongsToSession;
		column: 'Directory' text: #directory;
		column: 'Directory evidence' text: #directorySelectionReason
]

{ #category : #'gt - views' }
GtLACPClaudeCodeStoredSession >> gtTitlesFor: aView [
	"Which title is selected, and why were other candidates not selected?"

	<gtView>
	^ aView columnedList
		title: 'Title evidence';
		priority: -10;
		items: [ self titleRecords ];
		column: 'Line' text: [ :record | record lineNumber ifNil: [ 'sidecar' ] ];
		column: 'Field' text: #titleField;
		column: 'Title' text: #title;
		column: 'Priority' text: #priority;
		column: 'Decision' text: #selectionReason
]

{ #category : #accessing }
GtLACPClaudeCodeStoredSession >> issues [
	| result record |
	file ifNil: [ ^ #() ].
	self allRecords.
	self sidecarRecords.
	result := parseIssues copy.
	self records , self sidecarRecords
		do: [ :each | 
			each belongsToSession
				ifFalse: [ result
						add: (GtLACPStoredSessionReadIssue new
								file: each file;
								lineNumber: each lineNumber;
								description: 'Session ID disagrees with transcript filename';
								yourself) ] ].
	record := self directoryRecord.
	record
		ifNil: [ result
				add: (self newIssueAt: nil description: 'Project directory is unknown in transcript') ]
		ifNotNil: [ [ self directoryFromRecord: record ]
				on: Error
				do: [ :error | result add: (self newIssueAt: record lineNumber description: error messageText) ].
			(record rawData at: 'timestamp' ifAbsent: [ nil ])
				ifNotNil: [ :timestamp | 
					[ DateAndTime fromString: timestamp ]
						on: Error
						do: [ :error | 
							result
								add: (self
										issueAt: record lineNumber
										description: 'Invalid timestamp: ' , timestamp printString) ] ] ].
	^ result
]

{ #category : #accessing }
GtLACPClaudeCodeStoredSession >> metadataRecords [
	^ metadataRecords ifNil: [ metadataRecords := self parseMetadataRecords ]
]

{ #category : #loading }
GtLACPClaudeCodeStoredSession >> newClient [
	^ GtLACPClaudeCodeClient new
]

{ #category : #private }
GtLACPClaudeCodeStoredSession >> parseMetadataRecords [
	"Scan UTF-8 bytes using ASCII field markers. Decode only candidate metadata lines.
	The temporary ByteString is a byte container, not decoded user text."

	| result lineNumber foundDirectory |
	result := OrderedCollection new.
	lineNumber := 0.
	foundDirectory := false.
	self rawBytes asString
		linesDo: [ :line | 
			| needsDirectory hasTitle |
			lineNumber := lineNumber + 1.
			needsDirectory := foundDirectory not and: [ line includesSubstring: '"cwd"' ].
			hasTitle := #('"customTitle"' '"aiTitle"' '"summary"' '"slug"')
					anySatisfy: [ :marker | line includesSubstring: marker ].
			(needsDirectory or: [ hasTitle ])
				ifTrue: [ [ | data record |
					data := STONJSON fromString: line asByteArray utf8Decoded.
					(data isKindOf: Dictionary)
						ifTrue: [ record := GtLACPClaudeCodeTranscriptRecord from: data.
							record
								file: file;
								lineNumber: lineNumber;
								session: self.
							(record isTitleRecord or: [ needsDirectory and: [ record hasDirectory ] ])
								ifTrue: [ result add: record ].
							(record hasDirectory and: [ record belongsToSession ])
								ifTrue: [ foundDirectory := true ] ] ]
						on: Error
						do: [  "Detailed diagnostics are derived by the full parser on demand.":error |  ] ] ].
	^ result
]

{ #category : #private }
GtLACPClaudeCodeStoredSession >> parseSidecarRecords [
	| sidecar data record |
	file ifNil: [ ^ #() ].
	sidecar := file parent / self sessionId / 'custom-title.json'.
	sidecar exists ifFalse: [ ^ #() ].
	^ [ data := STONJSON fromString: sidecar contents.
	(data isKindOf: Dictionary) ifFalse: [ self error: 'Expected a JSON object' ].
	(data includesKey: 'customTitle')
		ifFalse: [ #() ]
		ifTrue: [ record := GtLACPClaudeCodeTranscriptRecord from: data.
			record
				file: sidecar;
				session: self.
			{record} ] ]
		on: Error
		do: [ :error | 
			parseIssues
				add: (GtLACPStoredSessionReadIssue new
						file: sidecar;
						description: error messageText;
						yourself).
			#() ]
]

{ #category : #reading }
GtLACPClaudeCodeStoredSession >> read [
	super read.
	metadataRecords := nil.
	sidecarRecords := nil.
	^ self
]

{ #category : #private }
GtLACPClaudeCodeStoredSession >> recordFrom: aDictionary [
	^ GtLACPClaudeCodeTranscriptRecord from: aDictionary
]

{ #category : #accessing }
GtLACPClaudeCodeStoredSession >> records [
	^ self allRecords
		select: [ :record | GtLACPClaudeCodeTranscriptRecord includesMetadata: record rawData ]
]

{ #category : #reading }
GtLACPClaudeCodeStoredSession >> selectedTitleRecord [
	| selected |
	selected := nil.
	self titleRecords
		do: [ :record | 
			record isUsable
				ifTrue: [ (selected isNil or: [ record priority >= selected priority ])
						ifTrue: [ selected := record ] ] ].
	^ selected
]

{ #category : #accessing }
GtLACPClaudeCodeStoredSession >> sidecarRecords [
	^ sidecarRecords ifNil: [ sidecarRecords := self parseSidecarRecords ]
]

{ #category : #accessing }
GtLACPClaudeCodeStoredSession >> sources [
	| metadata |
	file ifNil: [ ^ super sources ].
	metadata := {'filenameSessionId' -> self sessionId} asDictionary.
	self directoryRecord ifNotNil: [ :record | metadata addAll: record rawData ].
	^ {GtLACPStoredSessionSource new
			file: file;
			format: #claudeTranscript;
			metadata: metadata;
			yourself}
]

{ #category : #accessing }
GtLACPClaudeCodeStoredSession >> title [
	file ifNil: [ ^ super title ].
	^ title
		ifNil: [ title := self selectedTitleRecord
					ifNil: [ '' ]
					ifNotNil: [ :record | record title ] ]
]

{ #category : #accessing }
GtLACPClaudeCodeStoredSession >> titleRecords [
	^ (self metadataRecords select: #isTitleRecord) , self sidecarRecords
]
