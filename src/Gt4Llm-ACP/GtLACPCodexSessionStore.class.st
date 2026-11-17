"
I discover Codex sessions from index entries and byte-streamed rollout headers. sessions is the default browsing collection: known internal and delegated subagents are omitted, while missing origin metadata remains visible. allSessions retains every discovered session for provenance and direct lookup. Agent origins, internalAgents and subagents operate on that complete collection. Full rollout bodies remain unread until requested. Compressed files expose filename identity and explicit coverage issues; SQLite indices are not opened.
"
Class {
	#name : #GtLACPCodexSessionStore,
	#superclass : #GtLACPExternalSessionStore,
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #accessing }
GtLACPCodexSessionStore >> agentName [
 ^ 'Codex'
]

{ #category : #accessing }
GtLACPCodexSessionStore >> allSessions [
	"All discovered sessions, including internal and delegated agents."

	^ super sessions
]

{ #category : #defaults }
GtLACPCodexSessionStore >> defaultDirectory [
 | configured |
 configured := OSEnvironment current at: 'CODEX_HOME' ifAbsent: [ nil ].
 ^ configured isEmptyOrNil
  ifTrue: [ (FileLocator home / '.codex') asFileReference ]
  ifFalse: [ configured asFileReference ]
]

{ #category : #'gt - views' }
GtLACPCodexSessionStore >> gtAgentOriginsFor: aView [
	"Which discovered sessions are internal or delegated agents, including those omitted from Sessions?"

	<gtView>
	^ aView columnedList
		title: 'Agent origins';
		priority: 5;
		items: [ self allSessions ];
		column: 'Kind' text: #agentKind;
		column: 'Title' text: #title;
		column: 'Agent' text: [ :session | session agentNickname ifNil: [ '' ] ];
		column: 'Path' text: [ :session | session agentPath ifNil: [ '' ] ];
		column: 'Parent thread'
			text: [ :session | session parentThreadId ifNil: [ '' ] ];
		column: 'Session ID' text: #sessionId
]

{ #category : #accessing }
GtLACPCodexSessionStore >> internalAgents [
	^ self allSessions select: #isInternalAgent
]

{ #category : #accessing }
GtLACPCodexSessionStore >> issues [
	^ super issues , (sessions values flatCollect: #issues)
]

{ #category : #clients }
GtLACPCodexSessionStore >> newClient [
	^ GtLACPCodexClient new
]

{ #category : #reading }
GtLACPCodexSessionStore >> readCompressedRollout: aFile [
	[ | basename identifier record |
	basename := aFile basename allButLast: '.jsonl.zst' size.
	identifier := basename last: 36.
	UUID fromString: identifier.
	record := GtLACPCodexCompressedRolloutRecord new
			file: aFile;
			rawData: {'filenameSessionId' -> identifier} asDictionary;
			yourself.
	(self sessionAt: identifier) addRecord: record ]
		on: Error
		do: [ :error | 
			self
				issueFor: aFile
				line: nil
				description: error messageText ]
]

{ #category : #reading }
GtLACPCodexSessionStore >> readIndex: aFile [
	self
		readJsonLines: aFile
		limit: Float infinity
		do: [ :data :line | 
			| record |
			record := GtLACPCodexIndexRecord new
					file: aFile;
					lineNumber: line;
					rawData: data;
					yourself.
			(self sessionAt: record sessionId) addRecord: record.
			false ]
]

{ #category : #reading }
GtLACPCodexSessionStore >> readRollout: aFile [
	| found |
	found := false.
	self
		readJsonLines: aFile
		limit: 50
		do: [ :data :line | 
			(data at: 'type' ifAbsent: [ '' ]) = 'session_meta'
				ifFalse: [ false ]
				ifTrue: [ | record |
					record := GtLACPCodexRolloutRecord new
							file: aFile;
							lineNumber: line;
							rawData: (data at: 'payload');
							yourself.
					(self sessionAt: record sessionId) addRecord: record.
					found := true.
					true ] ].
	found
		ifFalse: [ self
				issueFor: aFile
				line: nil
				description: 'No session_meta record found in the first 50 records' ]
]

{ #category : #reading }
GtLACPCodexSessionStore >> readSessions [
 | index |
 index := rootDirectory / 'session_index.jsonl'.
 index isFile ifTrue: [ self readIndex: index ].
 #('sessions' 'archived_sessions') do: [ :name |
  | directory |
  directory := rootDirectory / name.
  directory isDirectory ifTrue: [
   directory allChildren do: [ :file |
    file isFile ifTrue: [
     (file basename beginsWith: 'rollout-') ifTrue: [
      (file basename endsWith: '.jsonl') ifTrue: [ self readRollout: file ].
      (file basename endsWith: '.jsonl.zst') ifTrue: [ self readCompressedRollout: file ] ] ] ] ] ].
 rootDirectory children do: [ :file |
  ((file basename beginsWith: 'state_') and: [ file basename endsWith: '.sqlite' ]) ifTrue: [
   self issueFor: file line: nil
    description: 'SQLite index not read; discovery uses rollout files and session_index.jsonl' ] ]
]

{ #category : #accessing }
GtLACPCodexSessionStore >> sessions [
	"Browse top-level agents, excluding known subagents. Missing origin metadata stays visible."

	^ super sessions reject: #isSubagent
]

{ #category : #private }
GtLACPCodexSessionStore >> storedSessionClass [
	^ GtLACPCodexStoredSession
]

{ #category : #accessing }
GtLACPCodexSessionStore >> subagents [
	^ self allSessions select: #isSubagent
]
