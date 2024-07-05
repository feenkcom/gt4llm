from gtoolkit_bridge import gtView


class EncoderByte:
	def __init__(self, byte):
		self.byte = byte
		
	def number(self):
		return self.byte
		
	def name(self):
		return chr(self.byte)
		
	def __eq__(self, other):
		return self.byte == other.byte
		
	def __hash__(self):
		return hash(self.byte)


class EncodingResult:
	def __init__(self, input, ids, merges, vocab):
		self.input = input
		self.ids = ids
		self.merges = merges
		self.vocab = vocab
		
	@gtView
	def gtViewInput(self, builder):
		text = builder.textEditor()
		text.title("Input")
		text.priority(2)
		text.setString(self.input)
		return text

	@gtView
	def gtViewOutput(self, builder):
		clist = builder.columnedList()
		clist.title("Output")
		clist.priority(1)
		clist.items(lambda: self.ids)
		clist.column('Byte', lambda each: chr(each.byte) if each.byte < 256 else each.byte)
		return clist
		
	@gtView
	def gtViewMerges(self, builder):
		clist = builder.columnedList()
		clist.title("Merges")
		clist.priority(3)
		clist.items(lambda: self.merges)
		clist.column('Byte', lambda each: each.byte, columnWidth=100)
		clist.column('Pair', lambda each: [chr(char.byte) if char.byte < 256 else char.byte for char in each.pair])
		return clist


class BPEMerge:
	def __init__(self, byte, pair):
		self.byte = byte
		self.pair = pair
		self.performed_merges = []
		self.before_text = ''
		self.after_text = ''
		
	def add_merge(self, idx, old):
		self.performed_merges.append((idx, old))
		
	def number(self):
		return self.byte
		
	def name(self):
		return self.pair[0].name() + self.pair[1].name()


class BPEText:
	def __init__(self, tokens):
		self.tokens = tokens


class BPEEncoder:
    def __init__(self):
        # default: vocab size of 256 (all bytes), no merges, no patterns
        self.merges = {} # (int, int) -> int
        self.vocab = self._build_vocab() # int -> bytes    @gtView    def gtViewMerges(self, builder):        clist = builder.columnedList()        clist.title("Merges")        clist.priority(1)        clist.items(lambda: list(self.merges.items()))
        clist.column('Byte', lambda each: each[1])
        clist.column('Pair', lambda each: [chr(char.byte) if char.byte < 256 else char.byte for char in each[0]])        return clist 
    def _build_vocab(self):
        # vocab is simply and deterministically derived from merges
        vocab = {idx: bytes([idx]) for idx in range(256)}
        for (p0, p1), idx in self.merges.items():
            vocab[idx] = vocab[p0] + vocab[p1]
        return vocab    def train(self, text, vocab_size, verbose=False):
        assert vocab_size >= 256
        num_merges = vocab_size - 256

        # input text preprocessing
        text_bytes = text.encode("utf-8") # raw bytes
        ids = [EncoderByte(byte) for byte in text_bytes] # list of integers in range 0..255

        # iteratively merge the most common pairs to create new tokens
        merges = {} # (int, int) -> int
        vocab = {idx: bytes([idx]) for idx in range(256)} # int -> bytes
        for i in range(num_merges):
            # count up the number of times every consecutive pair appears
            stats = self.get_stats(ids)
            # find the pair with the highest count
            pair = max(stats, key=stats.get)
            # mint a new token: assign it the next available id
            idx = 256 + i
            # replace all occurrences of pair in ids with idx
            ids = self.merge(ids, pair, BPEMerge(idx, pair))
            # save the merge
            merges[pair] = idx
            vocab[idx] = vocab[pair[0].byte] + vocab[pair[1].byte]

        # save class variables
        self.merges = merges # used in encode()
        self.vocab = vocab   # used in decode()

    def decode(self, result):
        # given ids (list of integers), return Python string
        text_bytes = b"".join(self.vocab[idx.byte] for idx in result.ids)
        text = text_bytes.decode("utf-8", errors="replace")
        return text            def merge(self, ids, pair, merge):
        newids = []
        i = 0
        while i < len(ids):
            if i < len(ids) - 1 and ids[i].byte == pair[0].byte and ids[i+1].byte == pair[1].byte:                merge.add_merge(i, (ids[i], ids[i+1]))
                newids.append(merge)
                i += 2
            else:
                newids.append(ids[i])
                i += 1
        return newids            def get_stats(self, ids):
        counts = {}
        for pair in zip(ids, ids[1:]):
            counts[pair] = counts.get(pair, 0) + 1
        return counts

    def encode(self, text):
        # given a string text, return the token ids
        text_bytes = text.encode("utf-8") # raw bytes
        ids = [EncoderByte(byte) for byte in text_bytes] # list of integers in range 0..255        applied_merges = []
        while len(ids) >= 2:
            # find the pair with the lowest merge index
            stats = self.get_stats(ids)
            pair = min(stats, key=lambda p: self.merges.get(p, float("inf")))
            # subtle: if there are no more merges available, the key will
            # result in an inf for every single pair, and the min will be
            # just the first pair in the list, arbitrarily
            # we can detect this terminating case by a membership check
            if pair not in self.merges:
                break # nothing else can be merged anymore
            # otherwise let's merge the best pair (lowest merge index)
            merge = BPEMerge(self.merges[pair], pair)            merge.before_text = BPEText(ids.copy())            applied_merges.append(merge)
            ids = self.merge(ids, pair, merge)            merge.after_text = BPEText(ids.copy())
        return EncodingResult(text, ids, applied_merges, self.vocab)
