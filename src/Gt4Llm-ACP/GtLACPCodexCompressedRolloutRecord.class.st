"
I preserve the filename identity of a compressed rollout and make unavailable metadata explicit.
"
Class {
	#name : #GtLACPCodexCompressedRolloutRecord,
	#superclass : #GtLACPCodexSessionRecord,
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #initialization }
GtLACPCodexCompressedRolloutRecord >> initialize [
	super initialize.
	format := #codexCompressedRollout
]

{ #category : #accessing }
GtLACPCodexCompressedRolloutRecord >> issues [
	^ {self
			newIssue: 'Compressed rollout: identity read from filename; metadata not decoded'}
]

{ #category : #metadata }
GtLACPCodexCompressedRolloutRecord >> metadataKeys [
	^ #('filenameSessionId')
]

{ #category : #accessing }
GtLACPCodexCompressedRolloutRecord >> selectionReason [
	^ 'Filename identity only; compressed metadata not decoded'
]

{ #category : #accessing }
GtLACPCodexCompressedRolloutRecord >> sessionId [
	^ metadata at: 'filenameSessionId'
]
