#ifndef BROKER_UTIL_HASH_HH
#define BROKER_UTIL_HASH_HH

#include <functional>

namespace broker {
namespace util {

/**
 * Calculate hash for an object and combine with a provided hash.
 */
template <typename T>
static inline void hash_combine(size_t& seed, const T& v)
	{ seed ^= std::hash<T>()(v) + 0x9e3779b9 + (seed<<6) + (seed>>2); }

/**
 * Allows hashing composite types.
 */
template <typename C>
struct container_hasher {
	using value_type = typename C::value_type;
	using result_type = typename std::hash<value_type>::result_type;
	using argument_type = C;

	inline result_type operator()(const argument_type& c) const
		{
		result_type rval{};
		for ( const auto& e : c )
			hash_combine<value_type>(rval, e);
		return rval;
		}
};

} // namespace util
} // namespace broker

#endif // BROKER_UTIL_HASH_HH
