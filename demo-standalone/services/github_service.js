/**
 * GitHub API Service
 * Servicio para buscar código similar en GitHub
 */

const fetch = require('node-fetch');
require('dotenv').config();

class GitHubService {
  constructor() {
    this.token = process.env.GITHUB_TOKEN;
    this.apiUrl = process.env.GITHUB_API_URL || 'https://api.github.com';
  }

  /**
   * Buscar código en GitHub
   */
  async searchCode(query, language = null, maxResults = 10) {
    try {
      // Construir query
      let searchQuery = query;
      if (language) {
        searchQuery += ` language:${language}`;
      }

      const response = await fetch(
        `${this.apiUrl}/search/code?q=${encodeURIComponent(searchQuery)}&per_page=${maxResults}`,
        {
          headers: {
            'Authorization': `token ${this.token}`,
            'Accept': 'application/vnd.github.v3+json',
            'User-Agent': 'AI-Assignment-Checker'
          }
        }
      );

      if (!response.ok) {
        if (response.status === 403) {
          throw new Error('Rate limit excedido. Espera un momento.');
        }
        throw new Error(`GitHub API error: ${response.status}`);
      }

      const data = await response.json();
      
      return {
        total: data.total_count,
        items: data.items.map(item => ({
          name: item.name,
          path: item.path,
          repository: item.repository.full_name,
          url: item.html_url,
          score: item.score
        }))
      };
    } catch (error) {
      console.error('Error buscando en GitHub:', error);
      throw error;
    }
  }

  /**
   * Obtener contenido de archivo
   */
  async getFileContent(owner, repo, path) {
    try {
      const response = await fetch(
        `${this.apiUrl}/repos/${owner}/${repo}/contents/${path}`,
        {
          headers: {
            'Authorization': `token ${this.token}`,
            'Accept': 'application/vnd.github.v3+json',
            'User-Agent': 'AI-Assignment-Checker'
          }
        }
      );

      if (!response.ok) {
        throw new Error(`GitHub API error: ${response.status}`);
      }

      const data = await response.json();
      
      // Decodificar contenido (viene en base64)
      const content = Buffer.from(data.content, 'base64').toString('utf-8');
      
      return {
        content,
        size: data.size,
        url: data.html_url,
        sha: data.sha
      };
    } catch (error) {
      console.error('Error obteniendo contenido:', error);
      throw error;
    }
  }

  /**
   * Detectar plagio externo
   */
  async detectExternalPlagiarism(code, language, threshold = 0.7) {
    try {
      // Extraer fragmentos significativos del código
      const fragments = this.extractCodeFragments(code);
      
      const results = [];
      
      for (const fragment of fragments) {
        // Buscar cada fragmento
        const searchResults = await this.searchCode(fragment, language, 5);
        
        if (searchResults.total > 0) {
          results.push({
            fragment,
            matches: searchResults.items,
            totalMatches: searchResults.total
          });
        }
        
        // Respetar rate limit (esperar 1 segundo entre búsquedas)
        await new Promise(resolve => setTimeout(resolve, 1000));
      }
      
      // Calcular score de similitud
      const similarityScore = this.calculateSimilarityScore(results, fragments.length);
      
      return {
        isPlagiarized: similarityScore >= threshold,
        similarityScore,
        matches: results,
        totalFragments: fragments.length,
        matchedFragments: results.length
      };
    } catch (error) {
      console.error('Error detectando plagio externo:', error);
      throw error;
    }
  }

  /**
   * Extraer fragmentos de código significativos
   */
  extractCodeFragments(code, minLength = 50) {
    const fragments = [];
    const lines = code.split('\n');
    
    // Extraer funciones y bloques significativos
    let currentFragment = '';
    
    for (const line of lines) {
      const trimmed = line.trim();
      
      // Ignorar comentarios y líneas vacías
      if (trimmed === '' || trimmed.startsWith('//') || trimmed.startsWith('#')) {
        continue;
      }
      
      currentFragment += line + '\n';
      
      // Si el fragmento es suficientemente largo, guardarlo
      if (currentFragment.length >= minLength) {
        fragments.push(currentFragment.trim());
        currentFragment = '';
      }
    }
    
    // Agregar último fragmento si existe
    if (currentFragment.trim().length >= minLength) {
      fragments.push(currentFragment.trim());
    }
    
    return fragments.slice(0, 5); // Máximo 5 fragmentos para no exceder rate limit
  }

  /**
   * Calcular score de similitud
   */
  calculateSimilarityScore(results, totalFragments) {
    if (totalFragments === 0) return 0;
    
    const matchedFragments = results.length;
    return matchedFragments / totalFragments;
  }

  /**
   * Verificar rate limit
   */
  async checkRateLimit() {
    try {
      const response = await fetch(`${this.apiUrl}/rate_limit`, {
        headers: {
          'Authorization': `token ${this.token}`,
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'AI-Assignment-Checker'
        }
      });

      if (!response.ok) {
        throw new Error(`GitHub API error: ${response.status}`);
      }

      const data = await response.json();
      
      return {
        limit: data.rate.limit,
        remaining: data.rate.remaining,
        reset: new Date(data.rate.reset * 1000),
        searchLimit: data.resources.search.limit,
        searchRemaining: data.resources.search.remaining
      };
    } catch (error) {
      console.error('Error verificando rate limit:', error);
      throw error;
    }
  }

  /**
   * Buscar repositorios
   */
  async searchRepositories(query, maxResults = 10) {
    try {
      const response = await fetch(
        `${this.apiUrl}/search/repositories?q=${encodeURIComponent(query)}&per_page=${maxResults}`,
        {
          headers: {
            'Authorization': `token ${this.token}`,
            'Accept': 'application/vnd.github.v3+json',
            'User-Agent': 'AI-Assignment-Checker'
          }
        }
      );

      if (!response.ok) {
        throw new Error(`GitHub API error: ${response.status}`);
      }

      const data = await response.json();
      
      return {
        total: data.total_count,
        items: data.items.map(item => ({
          name: item.name,
          fullName: item.full_name,
          description: item.description,
          url: item.html_url,
          stars: item.stargazers_count,
          language: item.language
        }))
      };
    } catch (error) {
      console.error('Error buscando repositorios:', error);
      throw error;
    }
  }
}

module.exports = GitHubService;
