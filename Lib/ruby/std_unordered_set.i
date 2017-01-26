/*
  Sets
*/

%include <std_set.i>

%fragment("StdUnorderedSetTraits","header",fragment="<stddef.h>",fragment="StdSequenceTraits")
%{
  namespace swig {
    template <class RubySeq, class T> 
    inline void 
    assign(const RubySeq& rubyseq, std::unordered_set<T>* seq) {
      // seq->insert(rubyseq.begin(), rubyseq.end()); // not used as not always implemented
      typedef typename RubySeq::value_type value_type;
      typename RubySeq::const_iterator it = rubyseq.begin();
      for (;it != rubyseq.end(); ++it) {
	seq->insert(seq->end(),(value_type)(*it));
      }
    }

    template <class T>
    struct traits_asptr<std::unordered_set<T> >  {
      static int asptr(VALUE obj, std::unordered_set<T> **s) {  
	return traits_asptr_stdseq<std::unordered_set<T> >::asptr(obj, s);
      }
    };

    template <class T>
    struct traits_from<std::unordered_set<T> > {
      static VALUE from(const std::unordered_set<T>& vec) {
	return traits_from_stdseq<std::unordered_set<T> >::from(vec);
      }
    };


    /** 
     * Set Iterator class for an iterator with no end() boundaries.
     *
     */
    template<typename InOutIterator, 
	     typename ValueType = typename std::iterator_traits<InOutIterator>::value_type,
	     typename FromOper = from_oper<ValueType>,
	     typename AsvalOper = asval_oper<ValueType> >
      class SetIteratorOpen_T :  public Iterator_T<InOutIterator>
    {
    public:
      FromOper  from;
      AsvalOper asval;
      typedef InOutIterator nonconst_iter;
      typedef ValueType value_type;
      typedef Iterator_T<nonconst_iter>  base;
      typedef SetIteratorOpen_T<InOutIterator, ValueType, FromOper, AsvalOper> self_type;

    public:
      SetIteratorOpen_T(nonconst_iter curr, VALUE seq = Qnil)
	: Iterator_T<InOutIterator>(curr, seq)
      {
      }
    
      virtual VALUE value() const {
	return from(static_cast<const value_type&>(*(base::current)));
      }

      // no setValue allowed
    
      Iterator *dup() const
      {
	return new self_type(*this);
      }
    };


    /** 
     * Set Iterator class for a iterator where begin() and end() boundaries
       are known.
     *
     */
    template<typename InOutIterator, 
	     typename ValueType = typename std::iterator_traits<InOutIterator>::value_type,
	     typename FromOper = from_oper<ValueType>,
	     typename AsvalOper = asval_oper<ValueType> >
    class SetIteratorClosed_T :  public Iterator_T<InOutIterator>
    {
    public:
      FromOper   from;
      AsvalOper asval;
      typedef InOutIterator nonconst_iter;
      typedef ValueType value_type;
      typedef Iterator_T<nonconst_iter>  base;
      typedef SetIteratorClosed_T<InOutIterator, ValueType, FromOper, AsvalOper> self_type;
    
    protected:
      virtual Iterator* advance(ptrdiff_t n)
      {
	std::advance( base::current, n );
	if ( base::current == end )
	  throw stop_iteration();
	return this;
      }

    public:
      SetIteratorClosed_T(nonconst_iter curr, nonconst_iter first, 
		       nonconst_iter last, VALUE seq = Qnil)
	: Iterator_T<InOutIterator>(curr, seq), begin(first), end(last)
      {
      }
    
      virtual VALUE value() const {
	if (base::current == end) {
	  throw stop_iteration();
	} else {
	  return from(static_cast<const value_type&>(*(base::current)));
	}
      }

      // no setValue allowed
    
    
      Iterator *dup() const
      {
	return new self_type(*this);
      }

    private:
      nonconst_iter begin;
      nonconst_iter end;
    };

    // Template specialization to construct a closed iterator for sets
    // this turns a nonconst iterator into a const one for ruby to avoid
    // allowing the user to change the value
    template< typename InOutIter >
    inline Iterator*
    make_set_nonconst_iterator(const InOutIter& current, 
			       const InOutIter& begin,
			       const InOutIter& end, 
			       VALUE seq = Qnil)
    {
      return new SetIteratorClosed_T< InOutIter >(current, 
						  begin, end, seq);
    }

    // Template specialization to construct an open iterator for sets
    // this turns a nonconst iterator into a const one for ruby to avoid
    // allowing the user to change the value
    template< typename InOutIter >
    inline Iterator*
    make_set_nonconst_iterator(const InOutIter& current, 
			       VALUE seq = Qnil)
    {
      return new SetIteratorOpen_T< InOutIter >(current, seq);
    }

  }
%}

#define %swig_unordered_set_methods(set...) %swig_set_methods(set)

%mixin std::unordered_set "Enumerable";



%rename("delete")     std::unordered_set::__delete__;
%rename("reject!")    std::unordered_set::reject_bang;
%rename("map!")       std::unordered_set::map_bang;
%rename("empty?")     std::unordered_set::empty;
%rename("include?" )  std::unordered_set::__contains__ const;
%rename("has_key?" )  std::unordered_set::has_key const;

%alias  std::unordered_set::push          "<<";


%include <std/std_unordered_set.i>

